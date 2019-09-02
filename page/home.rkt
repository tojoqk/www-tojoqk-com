#lang typed/racket
(require "../request.rkt"
         "../response.rkt"
         "../renderer.rkt"
         "../template.rkt")
(provide page/home)

(: page/home (-> Request Response))
(define (page/home req)
  (response/renderer/html5
   (template/main
    #:category "ホーム"
    #:body
    (list
     (h1 "TojoQK の 個人的なホームページにようこそ！")
     (p "こんにちは！ TojoQK の個人的なホームページです。")
     (p "主にゲームや日記(未実装)を公開する予定です。")
     (h2 "目次")
     (ul
      (list
       (li (h3 (a #:href "/game" "Game")))
       (li (h3 (a #:href "/about-me" "About me")))))))))
