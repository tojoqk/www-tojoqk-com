#lang racket
(require "servlet.rkt"
         "template.rkt"
         "cdn.rkt"
         json
         net/url
         http/request
         net/http-client
         web-server/servlet-env
         web-server/stuffers
         web-server/stuffers/store
         aws/keys
         aws/util
         file/md5
         web-server/http/bindings
         web-server/http/request-structs
         (only-in srfi/13 string-index)
         (only-in racket/string string-join)
         aws/dynamo)
(provide root web)

(module+ test
  (require rackunit))

(define host "127.0.0.1")
(define port 8080)

(define (root event)
  (hash 'statusCode 301
        'headers (hash 'location "/home")))

(define (request event)
  (let retry ([c 10])
    (with-handlers ([exn:fail:network?
                     (λ (e)
                       (when (zero? c)
                         (raise e))
                       (sleep 0.1)
                       (retry (sub1 c)))])
      (let ([request-context (hash-ref event 'requestContext)])
        (let ([path (hash-ref request-context 'path)])
          (http-sendrecv host
                         path
                         #:port port
                         #:headers
                         (for/list ([(key val)
                                     (hash-ref event 'headers)])
                           (format "~a: ~a" key val))))))))

(define (header/bytes->pair header/bytes)
  (let ([header (bytes->string/utf-8 header/bytes)])
    (cond
      [(and (string? header)
            (string-index header #\:))
       => (λ (index)
            (cons
             (string->symbol (substring header 0 index))
             (substring header (+ index 2))))]
      [else #f])))

(define (write-log event code)
  (let* ([request-context (hash-ref event 'requestContext)]
         [identity (hash-ref request-context 'identity)])
    (printf "{~a}~%"
            (string-join
             (map (λ (p) (format "\"~a\":~a"
                                 (car p)
                                 (jsexpr->string (cdr p))))
                  (list (cons 'requestTime
                              (hash-ref request-context 'requestTime))
                        (cons 'requestTimeEpoch
                              (hash-ref request-context 'requestTimeEpoch))
                        (cons 'requestId (hash-ref request-context 'requestId))
                        (cons 'method (hash-ref request-context 'httpMethod))
                        (cons 'path (hash-ref request-context 'path))
                        (cons 'queryStringParameters
                              (hash-ref event 'queryStringParameters))
                        (cons 'multiValueQueryStringParameters
                              (hash-ref event
                                        'multiValueQueryStringParameters))
                        (cons 'statusCode code)
                        (cons 'sourceIp (hash-ref identity 'sourceIp))
                        (cons 'userAgent (hash-ref identity 'userAgent))))
             ","))))

(define init? (make-parameter #t))
(define (web event)
  (public-key (getenv "AWS_ACCESS_KEY_ID"))
  (private-key (getenv "AWS_SECRET_ACCESS_KEY"))
  (session-token (getenv "AWS_SESSION_TOKEN"))
  (when (init?)
    (dynamo-endpoint (endpoint "dynamodb.ap-northeast-1.amazonaws.com" #t))
    (dynamo-region "ap-northeast-1")
    (dynamo-api-version "20120810")
    (thread
     (lambda ()
       (serve/servlet start
                      #:stateless? #t
                      #:listen-ip host
                      #:servlet-regexp #rx""
                      #:command-line? #t
                      #:stuffer stuffer
                      #:port port)))
    (init? #f))
  (let-values ([(status headers body) (request event)])
    (let ([status-code (string->number
                        (second (string-split (bytes->string/utf-8 status))))]
          [headers (make-immutable-hash (filter-map header/bytes->pair headers))]
          [body (port->string body)])
      (write-log event status-code)
      (flush-output)
      (hash 'statusCode status-code
            'headers headers
            'body body))))

(define urls-table-name (make-parameter (getenv "URLS_TABLE_NAME")))

(define (dynamo-write k v)
  (dynamo-request "PutItem"
                  (hash
                   'Item (hash 'id (hash 'S (bytes->string/utf-8 k))
                               'value (hash 'S (bytes->string/utf-8 v))
                               'ttl (hash 'N
                                          (number->string
                                           (+ (current-seconds)
                                              3600))))
                   'TableName (urls-table-name)))
  (void))

(define (dynamo-read k)
  (match (dynamo-request "GetItem"
                         (hash
                          'Key (hash 'id (hash 'S (bytes->string/utf-8 k)))
                          'TableName (urls-table-name)))
    [(hash-table
      ['Item
       (hash-table
        ['value
         (hash-table
          ['S v])])])
     (string->bytes/utf-8 v)]))

(define stuffer
  (stuffer-chain
   serialize-stuffer
   (hash-stuffer md5
                 (make-store dynamo-write
                             dynamo-read))))

(module+ main
  (serve/servlet start
                 #:stateless? #t
                 #:listen-ip #f
                 #:launch-browser? #f
                 #:quit? #t
                 #:banner? #t
                 #:servlet-path "/home"
                 #:servlet-regexp #rx""
                 #:stuffer (stuffer-chain
                            serialize-stuffer
                            (md5-stuffer
                             (build-path (find-system-path 'home-dir)
                                         ".urls")))
                 #:port port))
