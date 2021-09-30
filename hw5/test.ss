(define e (list 
        (equal? (expr-compare 12 12) '12)
        (equal? (expr-compare 12 20) '(if % 12 20))
        (equal? (expr-compare #t #t) #t)
        (equal? (expr-compare #f #f) #f)
        (equal? (expr-compare #t #f) '%)
        (equal? (expr-compare #f #t) '(not %))
        (equal? (expr-compare '(/ 1 0) '(/ 1 0.0)) '(/ 1 (if % 0 0.0)))
))
(define m (list
        (equal? (expr-compare 'a '(cons a b)) '(if % a (cons a b)))
        (equal? (expr-compare '(cons a b) '(cons a b)) '(cons a b))
        (equal? (expr-compare '(cons a lambda) '(cons a λ)) '(cons a (if % lambda λ)))
        (equal? (expr-compare '(cons (cons a b) (cons b c))
                '(cons (cons a c) (cons a c))) '(cons (cons a (if % b c)) (cons (if % b a) c)))
        (equal? (expr-compare '(cons a b) '(list a b)) '((if % cons list) a b))
        (equal? (expr-compare '(list) '(list a)) '(if % (list) (list a)))
        (equal? (expr-compare ''(a b) ''(a c)) '(if % '(a b) '(a c)))
        (equal? (expr-compare '(quote (a b)) '(quote (a c))) '(if % '(a b) '(a c)))
        (equal? (expr-compare '(quoth (a b)) '(quoth (a c))) '(quoth (a (if % b c))))
        (equal? (expr-compare '(if x y z) '(if x z z)) '(if x (if % y z) z))
        (equal? (expr-compare '(if x y z) '(g x y z)) '(if % (if x y z) (g x y z)))
        (equal? (expr-compare '((lambda (a) (f a)) 1) '((lambda (a) (g a)) 2)) '((lambda (a) ((if % f g) a)) (if % 1 2)))
        (equal? (expr-compare '((lambda (a) (f a)) 1) '((λ (a) (g a)) 2)) '((λ (a) ((if % f g) a)) (if % 1 2)))
        (equal? (expr-compare '((lambda (a) a) c) '((lambda (b) b) d)) '((lambda (a!b) a!b) (if % c d)))
        (equal? (expr-compare ''((λ (a) a) c) ''((lambda (b) b) d)) '(if % '((λ (a) a) c) '((lambda (b) b) d)))
        (equal? (expr-compare '(+ #f ((λ (a b) (f a b)) 1 2))
                '(+ #t ((lambda (a c) (f a c)) 1 2))) '(+
                (not %)
                ((λ (a b!c) (f a b!c)) 1 2)))
        (equal? (expr-compare '((λ (a b) (f a b)) 1 2)
                '((λ (a b) (f b a)) 1 2)) '((λ (a b) (f (if % a b) (if % b a))) 1 2))
        (equal? (expr-compare '((λ (a b) (f a b)) 1 2)
                '((λ (a c) (f c a)) 1 2)) '((λ (a b!c) (f (if % a b!c) (if % b!c a))) 1 2))
        (equal? (expr-compare '((lambda (lambda) (+ lambda if (f lambda))) 3)
                '((lambda (if) (+ if if (f λ))) 3)) '((lambda (lambda!if) (+ lambda!if (if % if lambda!if) (f (if % lambda!if λ)))) 3))
        (equal? (expr-compare '((lambda (a) (eq? a ((λ (a b) ((λ (a b) (a b)) b a))
                                        a (lambda (a) a))))
                        (lambda (b a) (b a)))
                '((λ (a) (eqv? a ((lambda (b a) ((lambda (a b) (a b)) b a))
                                        a (λ (b) a))))
                        (lambda (a b) (a b)))) '((λ (a)
        ((if % eq? eqv?)
        a
        ((λ (a!b b!a) ((λ (a b) (a b)) (if % b!a a!b) (if % a!b b!a)))
                a (λ (a!b) (if % a!b a)))))
        (lambda (b!a a!b) (b!a a!b))))
))
(define o (list 
        (equal? (expr-compare '(cons a lambda) '(cons a λ)) '(cons a (if % lambda λ)))
        (equal? (expr-compare '(lambda (a) a) '(lambda (b) b)) '(lambda (a!b) a!b))
        (equal? (expr-compare '(lambda (a) b) '(cons (c) b)) '(if % (lambda (a) b) (cons (c) b)))
        (equal? (expr-compare '((λ (if) (+ if 1)) 3) '((lambda (fi) (+ fi 1)) 3)) '((λ (if!fi) (+ if!fi 1)) 3))
        (equal? (expr-compare '(lambda (lambda) lambda) '(λ (λ) λ)) '(λ (lambda!λ) lambda!λ))
        (equal? (expr-compare ''lambda '(quote λ)) '(if % 'lambda 'λ))
        (equal? (expr-compare '(lambda (a b) a) '(λ (b) b)) '(if % (lambda (a b) a) (λ (b) b)))
        (equal? (expr-compare '(λ (a b) (lambda (b) b)) '(lambda (b) (λ (b) b))) '(if % (λ (a b) (lambda (b) b)) (lambda (b) (λ (b) b))))
        (equal? (expr-compare '(λ (let) (let ((x 1)) x)) '(lambda (let) (let ((y 1)) y))) '(λ (let) (let (((if % x y) 1)) (if % x y))))
        (equal? (expr-compare '(λ (x) ((λ (x) x) x))
                '(λ (y) ((λ (x) y) x))) '(λ (x!y) ((λ (x) (if % x x!y)) (if % x!y x))))
        (equal? (expr-compare '(((λ (g)
                        ((λ (x) (g (λ () (x x))))
                        (λ (x) (g (λ () (x x))))))
                        (λ (r)                    
                        (λ (n) (if (= n 0)
                                1
                                (* n ((r) (- n 1)))))))
                        10)
                '(((λ (x)
                        ((λ (n) (x (λ () (n n))))
                        (λ (r) (x (λ () (r r))))))
                        (λ (g)
                        (λ (x) (if (= x 0)
                                1
                                (* x ((g) (- x 1)))))))
                        9)) '(((λ (g!x)
                        ((λ (x!n) (g!x (λ () (x!n x!n))))
                        (λ (x!r) (g!x (λ () (x!r x!r))))))
                        (λ (r!g)
                        (λ (n!x) (if (= n!x 0)
                                        1
                                        (* n!x ((r!g) (- n!x 1)))))))
                        (if % 10 9)))
))
(define h (list 
        (equal? (expr-compare '(lambda (a) (a)) '(lambda (b) (a))) '(lambda (a!b) ((if % a!b a))))
        (equal? (expr-compare '(lambda (a) a) '(lambda (b) a)) '(lambda (a!b) (if % a!b a)))
        (equal? (expr-compare '(lambda (a b) a) '(lambda (c d) (+ c d))) '(lambda (a!c b!d) (if % a!c (+ a!c b!d))))
        (equal? (expr-compare '(lambda (a b c) (if a b c)) '(lambda (d e f) (lambda (c) (c d e f))))
                '(lambda (a!d b!e c!f) (if % (if a!d b!e c!f) (lambda (c) (c a!d b!e c!f)))))
        (equal? (expr-compare '(λ (a b c) (if a b c)) '(lambda (d e f) (lambda (c) (c d e f))))
                '(λ (a!d b!e c!f) (if % (if a!d b!e c!f) (lambda (c) (c a!d b!e c!f)))))
        (equal? (expr-compare '(λ (a b c) (if a b c)) '(lambda (d e f) (lambda (c d) (c d e f))))
                '(λ (a!d b!e c!f) (if % (if a!d b!e c!f) (lambda (c d) (c d b!e c!f)))))
        (equal? (expr-compare '(λ (a if c) (if a if c)) '(lambda (d e f) (lambda (c d) (c d e f))))
                '(λ (a!d if!e c!f) (if % (if a!d if!e c!f) (lambda (c d) (c d if!e c!f)))))
        (equal? (expr-compare '(lambda (a) (lambda (a) (+ a 2))) '(lambda (b) (lambda (if) (if if b c))))
                '(lambda (a!b) (lambda (a!if) (if % (+ a!if 2) (if a!if a!b c)))))
        (equal? (expr-compare '(lambda (a) (lambda (a) (+ a 2))) '(lambda (b) (lambda (if b) (if if b c))))
                '(lambda (a!b) (if % (lambda (a) (+ a 2)) (lambda (if b) (if if b c)))))
        (equal? (expr-compare '(lambda (a) (lambda (a) (+ a 2))) '(lambda (if) (lambda (b c) (if if b c))))
                '(lambda (a!if) (if % (lambda (a) (+ a 2)) (lambda (b c) (if a!if b c)))))
        (equal? (expr-compare '(lambda (a) (lambda (b c) (+ a b))) '(lambda (b) (lambda (e c d) (+ b e c))))
                '(lambda (a!b) (if % (lambda (b c) (+ a!b b)) (lambda (e c d) (+ a!b e c)))))
        (equal? (expr-compare '(lambda (a) (quote (a b))) '(lambda (b) (quote (a b))))
                '(lambda (a!b) '(a b)))
        (equal? (expr-compare '(lambda (a) (a '(a d) c d)) '(lambda (b) (b '(a b) c d)))
                '(lambda (a!b) (a!b (if % '(a d) '(a b)) c d))) 
        (equal? (expr-compare '(lambda (a) (a (quote (a d)) c d)) '(lambda (b) (b '(a d) c d)))
                '(lambda (a!b) (a!b '(a d) c d))) 
        (equal? (expr-compare '(lambda (a) (quote (a d))) '(lambda (b) (b '(a d) c d)))
                '(lambda (a!b) (if % '(a d) (a!b '(a d) c d)))) 
        (equal? (expr-compare '(lambda (quote) (quote (quote 1))) '(lambda (a) (a (a 1))))
                '(lambda (quote!a) (if % ''1 (quote!a (quote!a 1)))))
))