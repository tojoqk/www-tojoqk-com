#lang typed/racket
(require "../request.rkt"
         "../renderer.rkt"
         "../response.rkt"
         "../template.rkt")
(provide not-found)

(: not-found (-> Request Response))
(define (not-found req)
  (response/renderer/html5
   #:code 404
   (template/main
    #:category "Not found"
    #:title "404 Not found"
    #:body
    (list
     (h1 "404 Not found")
     (p "申し訳ありません。URLに対応するコンテンツが見つかりませんでした。")
     (p `("ホームページは" ,(a #:href "/home" "こちら") "です。"))))))
