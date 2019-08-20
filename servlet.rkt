#lang web-server
(require "page/home.rkt"
         "page/not-found.rkt"
         "page/about-me.rkt"
         "page/game.rkt"
         "page/game/tic-tac-toe.rkt"
         "page/internal-server-error.rkt"
         "response.rkt"
         json)
(provide start loading-responder error-responder)

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
  (with-init req
    (top-dispatch req)))

(define (loading-responder url e)
  (displayln
   (jsexpr->string
    (hash 'phase "loading"
          'url (url->string url)
          'message (exn-message e))))
  (internal-server-error))

(define (error-responder url e)
  (displayln
   (jsexpr->string
    (hash 'phase "operating"
          'url (url->string url)
          'message (exn-message e))))
  (internal-server-error))
