#lang racket/base
(require "util/view.rkt")

(module+ test
  (require xml)
  (require rackunit))

(define (index input)
  (bootstrap
   '((title "Hello, World!"))
   '((h1 "Hello, world!"))))
(provide index)

(module+ test
  (check-pred string? (index 'a))
  (check-pred xexpr? (html5->xexpr (index 'a))))
