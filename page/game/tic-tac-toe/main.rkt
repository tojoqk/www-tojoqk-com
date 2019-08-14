#lang typed/racket
(provide make-board turn->string next board-ref board-set judge
         computer-choice)

(define-type Turn (U 'o 'x))
(define-type Board (Immutable-HashTable Natural Turn))

(define LENGTH 3)

(define (make-board) (hash))

(: position->choice (-> Natural Natural Natural))
(define (position->choice i j)
  (+ (* i LENGTH) j))

(: choice->position (-> Natural (Values Natural Natural)))
(define (choice->position n)
  (values (quotient n LENGTH)
          (modulo n LENGTH)))

(: turn->string (-> Turn String))
(define (turn->string t)
  (case t
    [(o) "o"]
    [(x) "x"]))

(: board-ref (-> Board Natural Natural (Option Turn)))
(define (board-ref b i j)
  (hash-ref b (position->choice i j) #f))

(: board-set (-> Board Natural Natural Turn Board))
(define (board-set b i j t)
  (hash-set b (position->choice i j) t))

(: next (-> Turn Turn))
(define (next t)
  (case t
    [(o) 'x]
    [(x) 'o]))

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
       (: return-zero (-> Zero))
       (define (return-zero) 0)
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

(: board->choices (-> Board (Listof Natural)))
(define (board->choices b)
  (for*/list : (Listof Natural) ([i : Natural (in-range LENGTH)]
                                 [j : Natural (in-range LENGTH)]
                                 #:when (not (board-ref b i j)))
    (position->choice i j)))

(: choice-scores (-> Turn Board (Listof (Pair Natural Integer))))
(define (choice-scores t b)
  (let ([all-choices (board->choices b)])
    (for/list : (Listof (Pair Natural Integer)) ([c1 : Natural all-choices])
      (let-values ([([i : Natural] [j : Natural]) (choice->position c1)])
        (let ([b1 : Board (board-set b i j t)])
          (cons
           c1
           (if (eq? 'win (judge t b1)) ; computer win!
               10000
               (for/sum : Integer ([c2 : Natural (board->choices b1)])
                 (let-values ([([i : Natural] [j : Natural]) (choice->position c2)])
                   (let ([b2 : Board (board-set b1 i j (next t))])
                     (for/sum : Integer ([c3 : Natural (board->choices b2)])
                       (let-values ([([i : Natural] [j : Natural]) (choice->position c3)])
                         (let ([b3 : Board (board-set b1 i j (next t))])
                           (- (if (eq? 'win (judge t b3))        ; computer win!
                                  1
                                  0)
                              (if (eq? 'win (judge (next t) b3)) ; computer lose!
                                  100
                                  0)))))))))))))))

(: random-ref (All (A) (-> (Listof A) A)))
(define (random-ref l)
  (list-ref l (random (length l))))

(: computer-choice (-> Turn Board (Values Natural Natural)))
(define (computer-choice t b)
  (let ([choice+scores : (Listof (Pairof Natural Integer)) (choice-scores t b)])
    (let ([max-score : Integer (apply max ((inst map Integer (Pairof Natural Integer)) cdr choice+scores))])
      (choice->position
       ((inst car Natural Integer)
        (random-ref
         (filter (λ ([p : (Pairof Natural Integer)]) (<= max-score (cdr p))) choice+scores)))))))
