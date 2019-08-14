#lang web-server
(require "../../response.rkt"
         "../../html.rkt"
         "../../template.rkt"
         "tic-tac-toe/main.rkt")
(provide game/tic-tac-toe)

(define (template/game/tic-tac-toe containts)
  (template/main
   #:category "げーむ"
   #:title "tic-tac-toe"
   #:head
   (list
    (style ".game-area {"
           "  display: flex;"
           "  align-items: center;"
           "  flex-direction: column;"
           "  height: 400px;"
           "  justify-content: space-between;"
           "}"
           ".board {"
           "  display: flex;"
           "  flex-direction: column;"
           "  justify-content: space-around;"
           "  width: 300px;"
           "  height: 300px;"
           "}"
           ".row {"
           "  display: flex;"
           "  justify-content: space-around;"
           "}"
           ".row a {"
           "  color: inherit;"
           "  text-decoration: none;"
           "}"
           ".cell {"
           "  width: 100px;"
           "  height: 100px;"
           "  outline: solid;"
           "  display: flex;"
           "  justify-content: center;"
           "  align-items: center;"
           "  font-size: xx-large;"
           "}"
           ))
   #:body
   (list
    (h1 "OXゲーム(tic-tac-toe)")
    (apply div
           #:class "game-area"
           containts))))

(define (game/tic-tac-toe req)
  (let ([b (make-board)])
    (start 'o b)))

(define (win t b)
  (response/xexpr/html5
   (template/game/tic-tac-toe
    (list
     (render-board b)
     (format "~aの勝ち!" t)
     (a #:href "/game/tic-tac-toe" "もう一度遊ぶ")))))

(define (draw t b)
  (response/xexpr/html5
   (template/game/tic-tac-toe
    (list
     (render-board b)
     "引き分け!"
     (a #:href "/game/tic-tac-toe" "もう一度遊ぶ")))))

(define (judge-and-next t b)
  (cond
    [(judge t b)
     => (λ (result)
          (case result
            [(win) (win t b)]
            [(draw) (draw t b)]
            [else (error 'start "Failed!")]))]
    [else
     (start (next t) b)]))

(define (start t b)
  (send/suspend/dispatch
   (λ (embed/url)
     (response/xexpr/html5
      (template/game/tic-tac-toe
       (list
        (render-board
         b
         (lambda (i j)
           (embed/url
            (let ([b (board-set b i j t)])
              (lambda (req)
                (judge-and-next t b))))))
        (a #:href (embed/url
                   (lambda (req)
                     (let-values ([(i j) (computer-choice t b)])
                       (let ([b (board-set b i j t)])
                         (judge-and-next t b)))))
           "コンピュータに選択させる")
        (a #:href "/game/tic-tac-toe"
           "リセットする")))))))

(define (render-board b [on-click #f])
  (apply
   div
   #:class "board"
   (for/list ([i (in-range 3)])
     (apply
      div
      #:class "row"
      (for/list ([j (in-range 3)])
        (cond
          [(board-ref b i j)
           =>
           (λ (t/ij)
             (div
              #:class "cell"
              (turn->string t/ij)))]
          [else
           (if on-click
               (a #:href (on-click i j)
                  (div #:class "cell"))
               (div #:class "cell"))]))))))
