#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide game)

(define (game req)
  (response/xexpr/html5
   (template/main
    #:category "げーむ"
    #:body
    (list
     (h1 "ゲーム")
     (ul
      (li (a #:href "./game/tic-tac-toe"
             "oxゲーム(tic-tac-toe)")))))))
