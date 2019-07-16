#lang racket/base
(provide src/cdn)

(define (src/cdn path)
  `[src ,(string-append "https://dwlsypxdguxvw.cloudfront.net" path)])
