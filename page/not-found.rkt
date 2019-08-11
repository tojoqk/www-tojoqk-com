#lang web-server
(require "../html.rkt"
         "../response.rkt"
         "../template.rkt")
(provide not-found)

(define (not-found req)
  (response/xexpr/html5
   #:code 404
   (template/main
    #:category "Not found"
    #:title "404 Not found"
    #:body
    (list
     (h1 "404 Not found")
     (p "申し訳ありません。URLに対応するコンテンツが見つかりませんでした。")
     (p "ホームページは" (a #:href "/home" "こちら") "です。")))))

