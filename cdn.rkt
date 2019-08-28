#lang typed/racket/base
(provide cdn/www-tojoqk-com)

(: www-tojoqk-com (-> String))
(define (www-tojoqk-com)
  (cond
    [(getenv "WWW_TOJOQK_COM_CDN") => values]
    [else "dwlsypxdguxvw.cloudfront.net"]))

(: cdn/www-tojoqk-com (-> String String))
(define (cdn/www-tojoqk-com path)
  (string-append "https://" (www-tojoqk-com) "/" path))

