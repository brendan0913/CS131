% Referenced TA repo
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).
transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
    lists_firsts_rests(Ms, Ts, Ms1),
    transpose(Rs, Ms1, Tss).
lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
    lists_firsts_rests(Rest, Fs, Oss).

get_element([R, C], T, E) :-
    nth(C, T, Row),
    nth(R, Row, E).

% Constraints (sum, product, difference, quotient)
constraint(T, +(S, L)) :-
    sum(L, T, S).
constraint(T, *(P, L)) :-
    product(L, T, P).
constraint(T, -(D, J, K)) :-
    difference(J, K, T, D).
constraint(T, /(Q, J, K)) :-
    quotient(J, K, T, Q).
% L is a list of squares, each of form [Row|Col], or [R|C]
sum([], _, 0).
sum([[R|C]|Rest], T, S) :-
    get_element([R,C], T, E),  
    sum(Rest, T, NS),
    NS #= S - E.
product([], _, 1).
product([[R|C]|Rest], T, P) :-
    get_element([R,C], T, E),  
    product(Rest, T, NP),
    NP #= P / E.
difference([R1|C1], [R2|C2], T, D) :-
    get_element([R1,C1], T, E1),
    get_element([R2,C2], T, E2),
    (D #= E1 - E2; D #= E2 - E1).
quotient([R1|C1], [R2|C2], T, Q) :-
    get_element([R1,C1], T, E1),
    get_element([R2,C2], T, E2),
    (Q #= E1 / E2; Q #= E2 / E1).

row(N, L) :-
    length(L, N), fd_domain(L, 1, N), fd_all_different(L).
matrix(N, T, Transpose):-
    length(T, N), maplist(row(N), T), 
    transpose(T, Transpose), maplist(row(N), Transpose).

kenken(N, C, T) :-
    matrix(N, T, Transpose),
    maplist(constraint(Transpose), C),
    maplist(fd_labeling, Transpose).

plain_domain(N, L) :- findall(M, between(1, N, M), L).

plain_row(N, L) :- 
    plain_domain(N, P), permutation(P, L).
plain_matrix(N, T, Transpose) :-
    length(T, N), maplist(plain_row(N), T), 
    transpose(T, Transpose), maplist(plain_row(N), Transpose).

plain_kenken(N, C, T) :-
    plain_matrix(N, T, Transpose), 
    maplist(constraint(Transpose), C).

/* 
noop_kenken: 
    noop_kenken(N, C, T, T_final), where
    N, C, and T are the same as for kenken/plain_kenken (except C does not 
    have operations), and
    T_final = a constraint list in the format of C but with a
    new correct operation instead of no operation.

    noop_kenken functions similarly to the kenken implementation, and because 
    there are only four operations, it can rule out operators that could not
    possibly be valid for a given cage, and try the remaining operators. If the
    target number is > N, then the only valid operations are multiplication or 
    addition, and likewise, if the target number is < N, the valid operations are
    division and subtraction, and if it is equal to N, then the valid operations
    are multiplication and division (with 1). There are also cases where the cage
    is a single cell; these constraints do not need an operation.

    On a successful call, N and C will be returned just as they are in kenken and 
    plain_kenken, T will have the list of list of integers to fill in the puzzle,
    and T_final will have the final constraint list in the format of C, but with
    the correct operations.
    On an unsuccessful call, noop_kenken will return no.

    An example test case for noop_kenken is:
    noop_kenken(
    4,
    [
        (6, [[1|1], [1|2], [2|1]]),
        (96, [[1|3], [1|4], [2|2], [2|3], [2|4]]),
        (1, [3|1], [3|2]),
        (1, [4|1], [4|2]),
        (8, [[3|3], [4|3], [4|4]]),
        (2, [[3|4]])
    ], T, T_final
    ).
    After the call, the value of N and C will be the same, T will have the list of list 
    of integers to fill in the puzzle, and T_final will have the list
    [
        +(6, [[1|1], [1|2], [2|1]]),
        *(96, [[1|3], [1|4], [2|2], [2|3], [2|4]]),
        -(1, [3|1], [3|2]),
        -(1, [4|1], [4|2]),
        +(8, [[3|3], [4|3], [4|4]]),
        *(2, [[3|4]])
    ]

*/

/* 
Statistics (used statistics/0 on the 4x4 test case given in the spec)
kenken:
    Memory                in use 
    trail  stack              4 Kb
    cstr   stack             10 Kb
    global stack              5 Kb
    local  stack              3 Kb
    atom   table        1795 atoms

    Times               since last

    user   time          0.000 sec
    system time          0.001 sec
    cpu    time          0.001 sec
    real   time          0.010 sec

plain_kenken:
    Memory               in use
    trail  stack           0 Kb
    cstr   stack           1 Kb
    global stack           6 Kb
    local  stack           7 Kb
    atom   table     1796 atoms

    Times             since last
    user   time       0.267 sec
    system time       0.001 sec
    cpu    time       0.268 sec
    real   time       0.270 sec
The fd solver kenken uses less memory on the global and local stack and
runs over 20 times faster than the plain_kenken solver.
*/

kenken_testcase(
    6,
    [
     +(11, [[1|1], [2|1]]),
     /(2, [1|2], [1|3]),
     *(20, [[1|4], [2|4]]),
     *(6, [[1|5], [1|6], [2|6], [3|6]]),
     -(3, [2|2], [2|3]),
     /(3, [2|5], [3|5]),
     *(240, [[3|1], [3|2], [4|1], [4|2]]),
     *(6, [[3|3], [3|4]]),
     *(6, [[4|3], [5|3]]),
     +(7, [[4|4], [5|4], [5|5]]),
     *(30, [[4|5], [4|6]]),
     *(6, [[5|1], [5|2]]),
     +(9, [[5|6], [6|6]]),
     +(8, [[6|1], [6|2], [6|3]]),
     /(2, [6|4], [6|5])
    ]
  ).

kenken_testcase4(
    4,
    [
        +(6, [[1|1], [1|2], [2|1]]),
        *(96, [[1|3], [1|4], [2|2], [2|3], [2|4]]),
        -(1, [3|1], [3|2]),
        -(1, [4|1], [4|2]),
        +(8, [[3|3], [4|3], [4|4]]),
        *(2, [[3|4]])
    ]
    ).
