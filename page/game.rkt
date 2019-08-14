#lang web-server
(require "../response.rkt"
         "../html.rkt"
         "../template.rkt")
(provide game)

(define (game req)
  (response/xexpr/html5
   (template/main
    #:category "ゲーム"
    #:body
    (list
     (h1 "Gameの一覧")
     (ul
      (li (a #:href "./game/tic-tac-toe"
             "oxゲーム(tic-tac-toe)")))))))
