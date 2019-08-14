#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide home)

(define (home req)
  (response/xexpr/html5
   (template/main
    #:category "ホーム"
    #:body
    (list
     (h1 "TojoQK の 個人的なホームページにようこそ！")
     (p "こんにちは！ TojoQK の個人的なホームページです。")
     (p "主にゲームや日記(未実装)を公開する予定です。")
     (p "ごゆっくりしていただければ幸いです。")
     (h2 "目次")
     (ul
      (li (h3 (a #:href "/game" "Game")))
      (li (h3 (a #:href "/about-me" "About me"))))))))
