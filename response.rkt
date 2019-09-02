#lang typed/racket
(provide response/renderer/html5 Response)
(require "renderer.rkt")
(require/typed xml [xexpr->string (-> Any String)])

(define-type Response (Immutable-HashTable Symbol Any))
(: response/renderer/html5 (-> Renderer
                               [#:code Natural]
                               [#:headers (Immutable-HashTable Symbol Any)]
                               Response))
(define (response/renderer/html5 xexpr
                                 #:code [code 200]
                                 #:headers [headers (hash)])
  (hash 'statusCode code
        'headers headers
        'body (string-append "<!DOCTYPE html>"
                             (xexpr->string
                              (renderer-render xexpr)))))
