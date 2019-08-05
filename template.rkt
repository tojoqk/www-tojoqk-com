#lang racket
(provide template/main)
(require "html.rkt"
         "cdn.rkt")

(define (template/main #:charset [charset "utf-8"]
                       #:icon [icon ""]
                       #:description [description #f]
                       head-proc
                       body-proc)
  (html #:lang "ja"
        (head-proc
         (lambda xs
           (apply head
                  (meta #:charset "utf-8")
                  (and icon (link #:rel "icon" #:href (cdn/www-tojoqk-com "QK-256x256.png")))
                  (and description
                       (meta #:name "description"
                             #:content description))
                  xs)))
        (body-proc body)))
