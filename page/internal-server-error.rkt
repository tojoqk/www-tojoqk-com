#lang typed/racket
(require "../request.rkt"
         "../response.rkt"
         "../renderer.rkt"
         "../template.rkt")
(provide page/internal-server-error)

(define (page/internal-server-error)
  (response/renderer/html5
   #:code 500
   (template/main
    #:category "Error"
    #:title "Internal Server Error"
    #:body
    (list
     (h1 "500 Internal Server Error")
     (p "サーバーで内部的なエラーが発生しました m(_ _)m")
     (p `("ホームページは" ,(a #:href "/home" "こちら") "です。"))))))
