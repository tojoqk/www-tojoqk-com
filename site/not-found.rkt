#lang web-server
(require "../html.rkt"
         "../response.rkt"
         "../template.rkt")
(provide not-found)

(define (not-found req)
  (response/xexpr/html5
   #:code 404
   (template/main
    (lambda (head)
      (head
       (title "Not Found")))
    (lambda (body)
      (body
       (h1 "存在しないページ")
       "このページは存在しません。")))))
