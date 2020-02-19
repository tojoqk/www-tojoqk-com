#lang racket

(provide root not-found)

(define (root event)
  (hash 'statusCode 301
        'headers (hash 'location "https://www.tojo.tokyo/")))

(define (not-found event)
  (hash 'statusCode 301
        'headers (hash 'location "https://www.tojo.tokyo/")))
