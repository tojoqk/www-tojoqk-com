#lang typed/racket
(provide make-board turn->string next board-ref board-set judge
         computer-choice)

(module+ test
  (require typed/rackunit))

(define-type Turn (U 'o 'x))
(define-type Board (Immutable-HashTable Natural Turn))


(define LENGTH 3)

(: make-board (-> Board))
(define (make-board) (hash))

(: position->choice (-> Natural Natural Natural))
(define (position->choice i j)
  (+ (* i LENGTH) j))

(module+ test
  (check-false (check-duplicates
                (for*/list : (Listof Natural) ([i : Natural (in-range LENGTH)]
                                               [j : Natural (in-range LENGTH)])
                  (position->choice i j)))))

(: choice->position (-> Natural (Values Natural Natural)))
(define (choice->position n)
  (values (quotient n LENGTH)
          (modulo n LENGTH)))

(module+ test
  (check-true (for/and ([i : Natural (in-range LENGTH)]
                        [j : Natural (in-range LENGTH)])
                (let ([c (position->choice i j)])
                  (let-values ([([i* : Natural] [j* : Natural]) (choice->position c)])
                    (and (= i i*)
                         (= j j*)))))))

(: turn->string (-> Turn String))
(define (turn->string t)
  (case t
    [(o) "o"]
    [(x) "x"]))

(module+ test
  (check-equal? (turn->string 'o) "o")
  (check-equal? (turn->string 'x) "x"))

(: board-ref (-> Board Natural Natural (Option Turn)))
(define (board-ref b i j)
  (hash-ref b (position->choice i j) #f))

(: board-set (-> Board Natural Natural Turn Board))
(define (board-set b i j t)
  (hash-set b (position->choice i j) t))

(module+ test
  (check-false (board-ref (make-board) 0 0))
  (check-equal? (board-ref (board-set (make-board) 0 0 'o) 0 0) 'o))

(: next (-> Turn Turn))
(define (next t)
  (case t
    [(o) 'x]
    [(x) 'o]))

(module+ test
  (check-equal? (next 'o) 'x)
  (check-equal? (next 'x) 'o))

(: judge (-> Turn Board (Option (U 'draw 'win))))
(define (judge t b)
  ;;; t win!
  ;; i = 0, i = 1, i = 2 (pattern i)
  ;; j = 0, j = 1, j = 2 (patttern j)
  ;; i - j = 0           (pattern i-j)
  ;; i + j + 1 = LENGTH  (pattern i+j)
  ((inst call/cc 'win (Option (U 'win 'draw)))
   (lambda ([k : (-> 'win Nothing)])
     (: escape/win (-> Integer Integer))
     (define (escape/win n)
       (if (= n LENGTH)
           (k 'win)
           n))
     (for*/fold ([pattern-i : (Immutable-HashTable Integer Integer) (hash)]
                 [pattern-j : (Immutable-HashTable Integer Integer) (hash)]
                 [pattern-i-j : Integer 0]
                 [pattern-i+j : Integer 0])
                ([i : Natural (in-range LENGTH)]
                 [j : Natural (in-range LENGTH)])
       (cond
         [(eqv? t (board-ref b i j))
          (values (hash-set pattern-i j (escape/win (add1 (or ((inst hash-ref Integer Integer) pattern-i j #f)
                                                              0))))
                  (hash-set pattern-j i (escape/win (add1 (or ((inst hash-ref Integer Integer) pattern-j i #f)
                                                              0))))
                  (escape/win
                   (if (= (- i j) 0)
                       (add1 pattern-i-j)
                       pattern-i-j))
                  (escape/win
                   (if (= (+ i j 1) LENGTH)
                       (add1 pattern-i+j)
                       pattern-i+j)))]
         [else
          (values pattern-i pattern-j pattern-i-j pattern-i+j)]))
     (if (= (hash-count b) 9)
         'draw
         #f))))

(module+ test
  ;; TODO: add judge's test
  )

(: board->choices (-> Board (Listof Natural)))
(define (board->choices b)
  (for*/list : (Listof Natural) ([i : Natural (in-range LENGTH)]
                                 [j : Natural (in-range LENGTH)]
                                 #:when (not (board-ref b i j)))
    (position->choice i j)))

(: board->score (-> Turn Board Natural Real))
(define (board->score t b n)
  (cond
    [(zero? n) 0.0]
    [else
     (+ (if (eq? (judge t b) 'win)
            1.0
            0.0)
        (for/sum : Real ([c : Natural (board->choices b)])
          (let-values ([(i j) (choice->position c)])
            (let ([b1 (board-set b i j (next t))])
              (if (eq? (judge (next t) b1) 'win)
                  -10.0
                  (for/sum : Real ([c : Natural (board->choices b1)])
                    (let-values ([(i j) (choice->position c)])
                      (let ([b2 (board-set b1 i j t)])
                        (* 0.1 (board->score t b2 (sub1 n)))))))))))]))

(: choice-scores (-> Turn Board Natural (Listof (Pair Natural Real))))
(define (choice-scores t b n)
  (for/list : (Listof (Pair Natural Real)) ([c : Natural (board->choices b)])
    (let-values ([(i j) (choice->position c)])
      (cons c (board->score t (board-set b i j t) n)))))

(: random-ref (All (A) (-> (Listof A) A)))
(define (random-ref l)
  (list-ref l (random (length l))))

(: computer-choice (-> Turn Board (Values Natural Natural)))
(define (computer-choice t b)
  (let ([choice+scores : (Listof (Pairof Natural Real)) (choice-scores t b 2)])
    (let ([max-score : Real (apply max ((inst map Real (Pairof Natural Real)) cdr choice+scores))])
      (choice->position
       ((inst car Natural Real)
        (random-ref
         (filter (λ ([p : (Pairof Natural Real)]) (<= max-score (cdr p))) choice+scores)))))))
