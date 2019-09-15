#lang typed/racket
(require "../request.rkt"
         "../response.rkt"
         "../renderer.rkt"
         "../template.rkt")
(provide page/about-me)

(: page/about-me (-> Request Response))
(define (page/about-me req)
  (response/renderer/html5
   (template/main
    #:category "紹介"
    #:head
    (list
     (style
      (list ".sns-title {"
            "  display: flex;"
            "  align-items: center;"
            "}"
            ".sns-link {"
            "  margin-left: 10px;"
            "}")))
    #:body
    (list
     (h1 "TojoQKについて")
     (p "QK には特に意味はありません。")
     (p (list
         "プログラミング言語の "
         (a #:href "https://racket-lang.org/" "Racket")
         " が好きです。"
         "この Web サイトも Racket で書かれています("
         (a #:href "https://github.com/tojoqk/www-tojoqk-com"
            "repo")
         ")。"))
     (div
      #:class "sns-title"
      (list
       (h2 "Twitter")
       (div
        (list
         (a #:class "sns-link" #:href "https://twitter.com/tojoqk" "@tojoqk")
         (p "唯一利用している SNS ですが、投稿の頻度はそれほど高くありません……。")
         (p (list
             "このホームページについての問い合わせは、"
             "Twitter で DM や Replay をしていただく形でお願いします。"))))))
     (div
      #:class "sns-title"
      (list
       (h2 "GitHub")
       (div
        (list
         (a #:class "sns-link"
            #:href "https://github.com/tojoqk/"
            "tojoqk")
         (p "TojoQK がソースコードを公開する目的で使用している git のホスティングサービスです。")))))))))
