#lang web-server
(require "page/home.rkt"
         "page/not-found.rkt"
         "page/about-me.rkt"
         "page/game.rkt"
         "page/game/tic-tac-toe.rkt")
(provide start)

(define-values (top-dispatch top-url)
  (dispatch-rules
   [("") (λ (req) (redirect-to "/home" permanently))]
   [("main") (λ (req) (redirect-to "/home" permanently))]
   [("home") home]
   [("game") game]
   [("game" "tic-tac-toe") game/tic-tac-toe]
   [("about-me") about-me]
   [else not-found]))

(define (start req)
  (top-dispatch req))
