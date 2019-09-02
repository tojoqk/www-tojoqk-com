#lang typed/racket
(require "../request.rkt"
         "../response.rkt"
         "../renderer.rkt"
         "../template.rkt")
(provide page/game)

(: page/game (-> Request Response))
(define (page/game req)
  (response/renderer/html5
   (template/main
    #:category "ゲーム"
    #:body
    (list
     (h1 "Gameの一覧")
     (ul
      (list
       (li (a "oxゲーム(tic-tac-toe) [工事中]"))))))))
