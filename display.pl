initialBoard([
[ninja,ninja,ninja,ninja,ninja,ninja,ninja,ninja],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[samurai,samurai,samurai,samurai,samurai,samurai,samurai,samurai]
]).

/* --------------------------------------------------------------- */

/* Board */
symbol(empty,S) :- S='-'.
symbol(ninja,S) :- S='N'.
symbol(samurai,S) :- S='S'.

/* Players */
piece(1, Symbol) :- Symbol = samurai.  
piece(2, Symbol) :- Symbol = ninja.

/* --------------------------------------------------------------- */

print_n(_, 0).
print_n(S, N):- 
    N > 0,
    NewN is N - 1,
    write(S),
    print_n(S, NewN).

print_text(String, Padding):-
    print_n(' ', Padding),
    write(String),
    print_n(' ', Padding).

/* --------------------------------------------------------------- */

printBoardHeader:-
    nl,
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |\n'),
    write('---|---|---|---|---|---|---|---|---|\n').

/* --------------------------------------------------------------- */

printBoardFooter:-
    write('---|---|---|---|---|---|---|---|---|\n\n').

/* --------------------------------------------------------------- */

printBoardRow([]):- nl.
printBoardRow([H | T]):-
    symbol(H, S),
    print_text(S, 1),
    write('|'), 
    printBoardRow(T).
    
/* --------------------------------------------------------------- */

printBoard([], _).
printBoard([H|T], Index):-
    NewIndex is Index + 1,
    print_text(Index, 1), write('|'),
    printBoardRow(H),
    printBoard(T, NewIndex).

/* --------------------------------------------------------------- */

printCurrentPlayer(Player):-
    write('Current Player: '), 
    write(Player), nl.

/* --------------------------------------------------------------- */

display_game(Board-Player):-
    printBoardHeader,
    printBoard(Board, 1),
    printBoardFooter,
    printCurrentPlayer(Player).




