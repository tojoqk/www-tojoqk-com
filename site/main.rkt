#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide main)

(define (main req)
  (response/xexpr/html5
   (template/main
    (lambda (head) (head (title "TojoQK")))
    (lambda (body)
      (body
       (h1 "トップページ")
       "最高にクールなサイトの紹介")))))
