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
                 [.container #:max-width 768px]])))
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
     ,@body)))

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

(define (about-me input)
  (define (link title url icon body)
    `(div ([class "media my-4"])
          (a ([href ,url])
             (img (,[src/static icon]
                   [class "mr-3"]
                   [width "64"] [height "64"]
                   [alt ,title])))
          (div ([class "media-body"])
               (h5 ([class "mt-0"])
                   (a ([href ,url])
                      ,title))
               ,body)))
  (template
   `(,(title "About me"))
   `((div ([class "container"])
          (h1 "About me")
          (ul ([class "list-unstyled"])
              ,(link "Twitter" "https://www.twitter.com/tojoqk" "Twitter.svg"
                     "TojoQKのTwitterアカウント")
              ,(link "GitHub" "https://www.github.com" "GitHub.svg"
                     "TojoQKのGitHubアカウント"))))))
(provide about-me)


(module+ test
  (check-pred string? (about-me (hash)))
  (check-pred xexpr? (html5->xexpr (about-me (hash)))))
