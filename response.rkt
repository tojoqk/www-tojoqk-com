#lang racket
(provide response/xexpr/html5)
(require web-server/http/xexpr)

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
