#lang racket
(provide html title)

(define (html head body)
  `(html
    ([lang "ja"])
    (head
     (meta ([charset "utf-8"]))
     ,@head)
    (body ,@body)))

(define (title [name #f])
  `(title
    ,(cond
       [name => (curry format "~a | TojoQK" name)]
       [else "TojoQK"])))
