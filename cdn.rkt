#lang racket/base
(provide cdn/www-tojoqk-com)

(define www-tojoqk-com
  (cond
    [(getenv "WWW_TOJOQK_COM_CDN") => values]
    [else "dwlsypxdguxvw.cloudfront.net"]))

(define (cdn/www-tojoqk-com path)
  (string-append "https://" www-tojoqk-com "/" path))

