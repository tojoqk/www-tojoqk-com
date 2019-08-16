#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide internal-server-error)

(define (internal-server-error)
  (response/xexpr/html5
   #:code 500
   (template/main
    #:category "Error"
    #:title "Internal Server Error"
    #:body
    (list
     (h1 "500 Internal Server Error")
     (p "サーバーで内部的なエラー発生しました m(_ _)m")
     (p "ホームページは" (a #:href "/home" "こちら") "です。")))))
