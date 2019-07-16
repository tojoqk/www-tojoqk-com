#lang racket/base
(require "template.rkt"
         "cdn.rkt"
         json
         xml)
(provide index)

(define (index event)
  (displayln (jsexpr->string event))
  (hash
   'statusCode 200
   'headers (hash 'Content-Type "text/html")
   'body
   (string-append
    "<!DOCTYPE html>"
    (xexpr->string
     (html
      `(,(title))
      `((p "ようこそ!")
        (p "こちらはTojoQKのホームページです。")))))))
