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
     (p "このホームページは TojoQK の暇つぶしのために作成されました。"
        "主にゲームや日記(未実装)の公開を行う予定です。")
     (h2 "目次")
     (ul
      (li (h3 (a #:href "/game" "Game"))
          (p "暇つぶしのために作ったゲーム")
          (p "継続ベースのフレームワークの実験"))
      (li (h3  (a #:href "/about-me" "About me"))
          (p "TojoQK に関する簡単な紹介")))))))
