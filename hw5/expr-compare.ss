#lang racket
(provide (all-defined-out))

(define (snd l) (car (cdr l)))
; Referenced TA Repo starting_hint.ss for lambda? and (beginning of) expr-compare
(define (lambda? x) 
  (member x '(lambda λ)))

(define (expr-compare x y)
  (cond [(equal? x y) x]
        [(and (boolean? x) (boolean? y)) (if x '% '(not %))]
        [(or (not (list? x)) (not (list? y))) (list 'if '% x y)]
        [(and (list? x) (list? y) (not (equal? (length x) (length y)))) (list 'if '% x y)]
        [(cond
            ; if only one of x or y is if
            [(and (or (equal? (car x) 'if) (equal? (car y) 'if)) (not (equal? (car x) (car y)))) (list 'if '% x y)]
            [(or (equal? (car x) 'quote) (equal? (car y) 'quote)) (list 'if '% x y)]  ; if either is a quote
            [(and (equal? (car x) 'lambda) (equal? (car x) (car y)))  ; if both lambda
                (cond
                  [(not (equal? (length (snd x)) (length (snd y)))) (list 'if '% x y)]
                  [(expr-lambda-start (cdr x) (cdr y) 'lambda '() '())])]
            [(and (lambda? (car x)) (lambda? (car y)))  ; if one or both are λ
                (cond
                  [(not (equal? (length (snd x)) (length (snd y)))) (list 'if '% x y)]
                  [(expr-lambda-start (cdr x) (cdr y) 'λ '() '())])]
            [(or (lambda? (car x)) (lambda? (car y))) (list 'if '% x y)]  ; if only one is λ
            [(expr-comp-list x y)])]))

(define (expr-comp-list x y)  ; Recursively go through x and y (lists of equal length that do not start with if, quote, lambda, or λ)
  (cond [(empty? y) '()]
        [(not (equal? (car x) (car y))) (cons (expr-compare (car x) (car y)) (expr-comp-list (cdr x) (cdr y)))]
        [(cons (car x) (expr-comp-list (cdr x) (cdr y)))]))

(define (expr-lambda-start x y lambda x-dict y-dict)  ; Create list of arguments and dictionaries for lambda
  (list lambda (expr-lambda-list (car x) (car y))
      (expr-lambda (snd x) (snd y)
                   (cons (build-dict (car x) (car y) 'x) x-dict)
                   (cons (build-dict (car x) (car y) 'y) y-dict))))

(define (expr-lambda-list x y)  ; Lambda args: if two variables a and b are different, combine into a!b
  (cond [(empty? y) '()]
        [(equal? (car x) (car y)) (cons (car x) (expr-lambda-list (cdr x) (cdr y)))]
        [(cons (string->symbol (string-append (symbol->string (car x)) (string-append "!" (symbol->string (car y)))))
            (expr-lambda-list (cdr x) (cdr y)))]))

(define (expr-lambda x y x-dict y-dict)   ; Lambda expression; update and compare x and y
  (let ([x-current (if (not (equal? (search-dict x-dict x) '-1)) (search-dict x-dict x) x)]  ; search for x in the dict
        [y-current (if (not (equal? (search-dict y-dict y) '-1)) (search-dict y-dict y) y)])  ; likewise for y
  (let ([updated-x (if (list? x) (update-dict #t x x-dict) x-current)]  ; update x's dict if x is a list; else use x-current
        [updated-y (if (list? y) (update-dict #t y y-dict) y-current)]) ; likewise for y
  (expr-compare updated-x updated-y))))   ; compare the updated x and y

(define (search-dict dict x) ; Searches for most current x in dict, with the most current being (car dict)
  (cond
    [(empty? dict) '-1]  ; no dict
    [(not (equal? (hash-ref (car dict) x '-1) '-1)) (hash-ref (car dict) x '-1)]  ; check current dict
    [(search-dict (cdr dict) x)])) ; check next dict

(define (build-dict x y is-x) ; Builds dictionary for x or y based on is-x
  (cond [(empty? y) (hash)]   ; initialize new dict
        [(equal? (car x) (car y)) (hash-set (build-dict (cdr x) (cdr y) is-x) (car x) (car x))] ; no need to build new dict
        [(let ([l (if (equal? is-x 'x) x y)] [is-l (if (equal? is-x 'x) 'x 'y)])  ; build new dict, either x->x!y or y->x!y
            (hash-set (build-dict (cdr x) (cdr y) is-l)
                (car l) (string->symbol (string-append (symbol->string (car x)) (string-append "!" (symbol->string (car y)))))))]))

(define (update-dict is-head? x x-dict) ; Update variables in the x dictionary, considering when x begins with if, lambda, or λ
  (cond
    [(empty? x) '()]
    [(equal? (car x) 'quote) x]
    [(boolean? (car x)) (cons (car x) (update-dict #f (cdr x) x-dict))]
    [(list? (car x)) (cons (update-dict #t (car x) x-dict) (update-dict #f (cdr x) x-dict))]
    [(and is-head? (equal? (car x) 'if)) (cons 'if (update-dict #f (cdr x) x-dict))]  ; if x begins with if
    [(and is-head? (lambda? (car x))) ; if x begins with lambda or λ
      (cons (car x) (cons (snd x) (update-dict #f (cdr (cdr x)) (cons (build-dict (snd x) (snd x) 'x) x-dict))))]
    [(let ([searched-x (if (equal? (search-dict x-dict (car x)) '-1) (car x) (search-dict x-dict (car x)))]) ; else, search x dict
      (cons searched-x (update-dict #f (cdr x) x-dict)))]))

; Referenced TA Repo starting_hint.ss for test-expr-compare
(define (test-expr-compare x y) 
  (and 
    (equal? (eval x) (eval `(let ((% #t)) ,(expr-compare x y))))
    (equal? (eval y) (eval `(let ((% #f)) ,(expr-compare x y))))
  )
)

(define test-expr-x '(lambda (a) (lambda (a) '(+ a '-1))))
(define test-expr-y '(lambda (b) (lambda (if) '(quote (if if b d)))))