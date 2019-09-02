#lang typed/racket
(require (for-syntax (only-in racket/list append-map)))
(provide Renderer renderer-render)
(struct renderer ([render : Sexp])
  #:transparent
  #:type-name Renderer)

(define-syntax (define-tag/provide stx)
  (define global-attrs '(id class hidden))
  (syntax-case stx ()
    [(k name (arg-attr ...))
     (with-syntax ([(attr ...) (append (syntax->list #'(arg-attr ...))
                                       (map (λ (sym) (datum->syntax #'k sym))
                                            global-attrs))])
       #`(begin
           (: name
              (->* ()
                   (#,@(append-map
                        (λ (attr-stx)
                          (let ([kattr (string->keyword (symbol->string (syntax->datum attr-stx)))])
                            (list kattr #'(Option String))))
                        (syntax->list #'(attr ...)))
                    (Option (U String (Listof (Option (U String Renderer))) Renderer)))
                   Renderer))
           (define (name
                    #,@(append-map
                        (λ (attr/syntax)
                          (let* ([attr/symbol (syntax->datum attr/syntax)]
                                 [attr/string (symbol->string attr/symbol)]
                                 [attr/keyword (string->keyword attr/string)])
                            `(,attr/keyword [,(datum->syntax #'k attr/symbol)
                                             #f])))
                        (syntax->list #'(attr ...)))
                    [expr #f])
             (let ([result : Sexp
                           `(name (,@(at 'attr attr) ...)
                                  ,@(cond
                                      [(not expr) '()]
                                      [(renderer? expr)
                                       (list (renderer-render expr))]
                                      [(string? expr)
                                       (list expr)]
                                      [else
                                       (filter-map (lambda ([x : (Option (U String Renderer))])
                                                     (cond
                                                       [(renderer? x) (renderer-render x)]
                                                       [else x]))
                                                   expr)]))])
               (renderer result)))
           (provide name)))]))

(: at (-> Symbol (U (Option (U String (-> (List Symbol String)))))
          (U (List (List Symbol String))
             Null)))
(define (at name value)
  (cond
    [(not value) '()]
    [(procedure? value) (list (value))]
    [else `([,name ,value])]))

(define-tag/provide html (lang))
(define-tag/provide head ())
(define-tag/provide body ())
(define-tag/provide title ())
(define-tag/provide nav ())
(define-tag/provide header ())
(define-tag/provide footer ())
(define-tag/provide section ())
(define-tag/provide article ())
(define-tag/provide aside ())
(define-tag/provide ol ())
(define-tag/provide ul ())
(define-tag/provide li ())
(define-tag/provide hl ())
(define-tag/provide h1 ())
(define-tag/provide h2 ())
(define-tag/provide h3 ())
(define-tag/provide h4 ())
(define-tag/provide h5 ())
(define-tag/provide h6 ())
(define-tag/provide p ())
(define-tag/provide meta (charset name content))
(define-tag/provide link (rel href))
(define-tag/provide a (href))
(define-tag/provide img (src alt title height width))
(define-tag/provide span ())
(define-tag/provide style (type))
(define-tag/provide div ())
(define-tag/provide em ())
