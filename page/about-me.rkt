#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide about-me)

(define (about-me req)
  (response/xexpr/html5
   (template/main
    #:category "紹介"
    #:head
    (list
     (style ".sns-title {"
            "  display: flex;"
            "  align-items: center;"
            "}"
            ".sns-link {"
            "  margin-left: 10px;"
            "}"))
    #:body
    (list
     (h1 "TojoQKについて")
     (p "QK には特に意味はありません。")
     (p "プログラミング言語の " (a #:href "https://racket-lang.org/" "Racket")  " が好きです。"
        "この Web サイトも Racket で書かれています("
        (a #:href "https://github.com/tojoqk/www-tojoqk-com"
           "repo")
        ")。")
     (div #:class "sns-title"
          (h2 "Twitter")
          (a #:class "sns-link" #:href "https://twitter.com/tojoqk" "@tojoqk"))
     (p "唯一利用している SNS ですが、投稿の頻度はそれほど高くありません……。")
     (p "このホームページについての問い合わせは、"
        "Twitter で DM や Replay をしていただく形でお願いします。")
     (div #:class "sns-title"
          (h2 "GitHub")
          (a #:class "sns-link" #:href "https://github.com/tojoqk/" "tojoqk"))
     (p "TojoQK がソースコードを公開する目的で使用している git のホスティングサービスです。")))))
