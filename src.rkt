#lang racket/base

(define (src/static path)
  `(src ,(string-append "https://dwlsypxdguxvw.cloudfront.net/" path)))

(provide src/static)
