#lang racket/base
(require "util/view.rkt")

(module+ test
  (require xml)
  (require rackunit))

(define (template head body)
  (bootstrap
   head
   '((nav ([class "navbar navbar-expand-sm navbar-light bg-light"])
          (div ([class "container"])
               (ul ([class "navbar-nav mr-auto"])
                   (li ([class "nav-item"])
                       (a ([class "navbar-brand"]
                           [href "/"])
                          "TojoQK")))))
     ,@body)))

(define (index input)
  (template
   '((title "TojoQK"))
   '((div ([class "container"])
          (img ([src "https://dwlsypxdguxvw.cloudfront.net/TojoQK.svg"]
                [class "img-fluid"]))
          "ようこそ!" (br)
          "こちらはTojoQKのホームページです。"))))
(provide index)

(module+ test
  (check-pred string? (index 'a))
  (check-pred xexpr? (html5->xexpr (index 'a))))
