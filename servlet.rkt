#lang web-server
(require web-server/http
         "site/not-found.rkt")
         "page/home.rkt"
(provide start)

(define-values (top-dispatch top-url)
  (dispatch-rules
   [("") (λ (req) (redirect-to "/home" permanently))]
   [("home") home]
   [else not-found]))

(define (start req)
  (top-dispatch req))
