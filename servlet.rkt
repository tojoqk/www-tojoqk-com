#lang web-server
(require web-server/http
         "page/home.rkt"
         "page/not-found.rkt"
         "page/about-me.rkt")
(provide start)

(define-values (top-dispatch top-url)
  (dispatch-rules
   [("") (λ (req) (redirect-to "/home" permanently))]
   [("home") home]
   [("about-me") about-me]
   [else not-found]))

(define (start req)
  (top-dispatch req))
