#lang racket
(require json
         "template.rkt"
         "page/home.rkt"
         "page/not-found.rkt")
(provide root
         home
         not-found)

(module+ test
  (require rackunit))

(define host "127.0.0.1")
(define port 8080)

(define (root event)
  (hash 'statusCode 301
        'headers (hash 'location "/home")))

(define (write-log event response)
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
                        (cons 'statusCode
                              (hash-ref 'statusCode response))
                        (cons 'sourceIp (hash-ref identity 'sourceIp))
                        (cons 'userAgent (hash-ref identity 'userAgent))))
             ","))
    response))

(define (home event)
  (write-log event (page/home event)))

(define (not-found event)
  (write-log event (page/home event)))
