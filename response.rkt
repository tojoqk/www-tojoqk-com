#lang racket
(provide response/xexpr/html5
         with-init)
(require web-server/http/xexpr
         web-server/lang/web
         web-server/private/servlet)

(define (response/xexpr/html5 xexpr
                              #:code [code 200]
                              #:message [message #f]
                              #:headers [headers empty]
                              #:cookies [cookies empty])
  (response/xexpr xexpr
                  #:preamble #"<!DOCTYPE html>"
                  #:code code
                  #:message message
                  #:headers headers
                  #:cookies cookies))

(define-syntax-rule (with-init req body body* ...)
  (call-with-init req (lambda () body body* ...)))

(define (call-with-init req thk)
  (current-execution-context
   (struct-copy execution-context (current-execution-context)
                [request req]))
  (thk))
