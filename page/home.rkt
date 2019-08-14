#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide home)

(define (home req)
  (response/xexpr/html5
   (template/main
    #:category "ほーむ"
    #:body
    (list
     (h1 "TojoQK の 個人的なホームページにようこそ！")
     (p "このホームページは意味もなく作られた、" (a #:href "/about-me" "TojoQK") "の暇つぶし用のホームページです。" )
     (p "ごゆっくりとお過ごしいただければ幸いです。")
     (h2 "Index")
     (ul
      (li (h3 (a #:href "/game" "Game"))
          (p "暇つぶしのために作ったゲーム")
          (p "Racket の Web サーバーの勉強のために作成した"))
      (li (h3  (a #:href "/about-me" "About me"))
          (p "TojoQK に関する簡単な紹介")))))))
