#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide about-me)

(define (about-me req)
  (response/xexpr/html5
   (template/main
    #:category "紹介"
    #:body
    (list
     (h1 "TojoQKについて")
     (h2 (a #:href "https://twitter.com/tojoqk" "Twitter"))
     (p "TojoQKのTwitterです。"
        "投稿の頻度はあまり高くはないですが、唯一利用しているSNSです。"
        "このホームページについて何かあったら、こちらのアカウントまで DM とか Replay していただければたぶん反応します。")
     (h2 (a #:href "https://github.com/tojoqk/" "GitHub"))
     (p "TojoQK がソースコードを公開する目的に使用している git のホスティングサービスです。"
        "たとえば、この Web サイトは" (a #:href "https://github.com/tojoqk/www-tojoqk-com" "こちら")
        "で開発されています。")))))
