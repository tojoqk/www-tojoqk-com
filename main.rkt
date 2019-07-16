#lang racket/base
(require "util/view.rkt"
         "src.rkt"
         css-expr)

(module+ test
  (require xml)
  (require rackunit))

(define title
  (case-lambda
    [() '(title "TojoQK")]
    [(name) `(title ,(format "~a | TojoQK" name))]))

(define (template head body)
  (bootstrap
   `((style
      ,(css-expr->css
        (css-expr
         [@media (#:min-width 768px)
                 [.container #:max-width 768px]]
         [html #:position relative
               #:min-height 100%]
         [body #:margin-bottom 60px]
         [.footer #:position absolute
                  #:bottom 0
                  #:width 100%
                  #:height 60px
                  #:background-color "#f5f5f5"])))
     ,@head)
   `((nav ([class "navbar navbar-expand-sm navbar-light bg-light"])
          (div ([class "container"])
               (ul ([class "navbar-nav mr-auto"])
                   (li ([class "nav-item"])
                       (a ([class "navbar-brand"]
                           [href "/"])
                          "TojoQK")))
               (ul ([class "nav navbar-nav"])
                   (li ([class "nav-item"])
                       (a ([class "navbar-text"]
                           [href "/about-me"])
                          "About me")))))
     (div ([class "container"])
          ,@body)
     (footer ([class "footer"])
             (div ([class "container"])
                  (p ([class "text-muted"])
                     "このWebサイトは"
                     (a ([href "https://racket-lang.org"])
                        "プログラミング言語Racket")
                     "で実装されています。"
                     "ソースは"
                     (a ([href "https://github.com/tojoqk/www-tojoqk-com"])
                        "こちら")
                     "。"))))))

(define (index input)
  (template
   `(,(title))
   `((div ([class "container"])
          (div ([class "row"])
               (div ([class "col-12"])
                    (img (,[src/static "TojoQK.svg"]
                          [class "img-fluid"]))))
          (div ([class "row"])
               (div ([class "col-12"])
                    (p "ようこそ!" (br)
                       "こちらはTojoQKのホームページです。")))))))
(provide index)

(module+ test
  (check-pred string? (index (hash)))
  (check-pred xexpr? (html5->xexpr (index (hash)))))


(module+ test
  (check-pred string? (about-me (hash)))
  (check-pred xexpr? (html5->xexpr (about-me (hash)))))
