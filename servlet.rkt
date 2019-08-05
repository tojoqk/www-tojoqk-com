#lang web-server
(require web-server/http
         "site/main.rkt"
         "site/not-found.rkt")
(provide start)

(define-values (top-dispatch top-url)
  (dispatch-rules
   [("") (λ (req) (redirect-to "/main" permanently))]
   [("main") main]
   [else not-found]))

(define (start req)
  (top-dispatch req))
