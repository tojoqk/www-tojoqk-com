#lang typed/racket
(provide template/main)
(require "renderer.rkt"
         "cdn.rkt")

(: max-width String)
(define max-width "960px")
(: min-width String)
(define min-width "720px")
(: title-bar-size String)
(define title-bar-size "680px")
(: title-image-size Natural)
(define title-image-size 128)

(: template/main (-> [#:charset String]
                     [#:icon String]
                     [#:description (Option String)]
                     [#:title (Option String)]
                     [#:head (Listof (U Renderer String False))]
                     #:category String
                     #:body (Listof (U Renderer String False))
                     Renderer))
(define (template/main #:charset [charset "utf-8"]
                       #:icon [icon ""]
                       #:description [description #f]
                       #:category category
                       #:title [title-string #f]
                       #:head [head-items '()]
                       #:body body-items)
  (html
   #:lang "ja"
   (list
    (head
     (append
      (list
       (meta #:charset "utf-8")
       (title (if title-string
                  (format "~a | TojoQK の ~a" title-string category)
                  (format "TojoQK の ~a" category)))
       (and icon (link #:rel "icon" #:href (cdn/www-tojoqk-com "QK-256x256.png")))
       (and description
            (meta #:name "description"
                  #:content description))
       (style #:type "text/css"
              (list
               ".title-bar-wrap {"
               "  display: flex;"
               "  align-items: center;"
               "  justify-content: center;"
               "}"
               ".title-bar {"
               "  display: flex;"
               (format "  width: ~a;" title-bar-size)
               "  align-items: center;"
               "  justify-content: space-between;"
               "}"
               ".title-string {"
               "  white-space: nowrap;"
               "  font-size: xx-large;"
               "}"
               ".world-wrap {"
               "  display: flex;"
               "  justify-content: center;"
               "}"
               ".world {"
               "  display: flex;"
               "  flex-direction: column;"
               "  justify-content: center;"
               "  width: 100%;"
               (format "  max-width: ~a;" max-width)
               (format "  min-width: ~a;" min-width)
               "}"
               ".navbar {"
               "  display: flex;"
               "  list-style: none;"
               "  justify-content: space-around;"
               "}"
               ".navbar-item {"
               "  font-size: large;"
               "}"
               ".main-wrap {"
               "  display: flex;"
               "  justify-content: center;"
               "}"
               ".main {"
               "  width: 85%;"
               "}")))
      head-items))
    (body
     #:class "world-wrap"
     (div
      #:class "world"
      (list
       (header
        (list
         (div #:class "title-bar-wrap"
              (let ([title-image
                     (img #:class "title-image"
                          #:width (format "~apx" title-image-size)
                          #:height (format "~apx" title-image-size)
                          #:src (cdn/www-tojoqk-com
                                 (format "TojoQK-circle-~ax~a.png"
                                         title-image-size
                                         title-image-size))
                          #:alt "")])
                (div #:class "title-bar"
                     (list
                      title-image
                      (span #:class "title-string"
                            (format "TojoQK の ~a" category))
                      title-image))))
         (nav
          (ul #:class "navbar"
              (map (λ ([item : Renderer])
                     (li #:class "navbar-item"
                         item))
                   (list
                    (a #:href "/home" "Home")
                    (a "Diary")
                    (a #:href "/game" "Game")
                    (a #:href "/about-me" "About me")))))))
       (div
        #:class "main-wrap"
        (article #:class "main"
                 body-items))))))))
