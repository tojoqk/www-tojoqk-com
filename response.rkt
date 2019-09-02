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
        'headers (hash 'Content-Type "text/html; charset=utf-8")
        'body (string-append "<!DOCTYPE html>"
                             (xexpr->string
                              (renderer-render xexpr)))))
