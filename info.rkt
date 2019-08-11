#lang info
(define collection "www-tojoqk-com")
(define deps '("base"
               "web-server-lib"
               "https://github.com/tojoqk/aws-lambda-serverless.git"
               "https://github.com/tojoqk/aws.git#session-token"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/www-tojoqk-com.scrbl" ())))
(define pkg-desc "My Web Site")
(define version "0.3")
(define pkg-authors '(tojoqk))
