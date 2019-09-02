#lang typed/racket
(provide Request)
(define-type Request (Immutable-HashTable Symbol Any))
