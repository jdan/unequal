% ===== BOILERPLATE
#!/usr/local/bin/swipl

:- initialization main.

bigger(4, 3).
bigger(4, 2).
bigger(4, 1).
bigger(3, 2).
bigger(3, 1).
bigger(2, 1).

solve([Row1, Row2, Row3, Row4]) :-
    Row1 = [C11, C12, C13, C14],
    Row2 = [C21, C22, C23, C24],
    Row3 = [C31, C32, C33, C34],
    Row4 =  [C41, C42, C43, C44],

    Col1 = [C11, C21, C31, C41],
    Col2 = [C12, C22, C32, C42],
    Col3 = [C13, C23, C33, C43],
    Col4 = [C14, C24, C34, C44],

    Set = [1, 2, 3, 4],

    permutation(Row1, Set),
    permutation(Row2, Set),
    permutation(Row3, Set),
    permutation(Row4, Set),

    permutation(Col1, Set),
    permutation(Col2, Set),
    permutation(Col3, Set),
    permutation(Col4, Set),
% ===== /BOILERPLATE

    bigger(C12, C13),
    bigger(C24, C34),
    bigger(C32, C33),
    bigger(C42, C32),
    C44 = 1.

% ===== BOILERPLATE
main :-
    solve(B),
    format('~q~n', [B]),
    halt.
% ===== /BOILERPLATE
