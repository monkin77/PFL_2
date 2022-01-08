initialBoard([
[n,n,n,n,n,n,n,n],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[e,e,e,e,e,e,e,e],
[s,s,s,s,s,s,s,s]
]).

/* --------------------------------------------------------------- */

/* Function that checks if the row has the element Symbol in position X*/
isInRowIndex(0, [Elem | _], Symbol):- !, fail.
isInRowIndex(0, [Symbol | _], Symbol). 
isInRowIndex(_, [], _):- fail.

isInRowIndex(X, [_ | T], Symbol):-
    NewX is X-1,
    isInRowIndex(NewX, T, Symbol).

/* --------------------------------------------------------------- */

moveXAxis(X, Y, Steps, Board, ResultingBoard, Symbol) :-
    NewX is X + Steps,
    NewX >= 0,
    NewX =< 7,
    placeSymbol(NewX, Y, Board, AuxBoard, [], Symbol),
    placeSymbol(X, Y, AuxBoard, ResultingBoard, [], e). /* place empty symbol in the position the element was */

moveYAxis(X, Y, Steps, Board, ResultingBoard, Symbol) :- 
    NewY is Y + Steps,
    NewY >= 0,
    NewY =< 7,
    /* TO DO
    verificar se a posição aonde colocar está empty
    verificar se o elemento na posicao inicial é igual ao symbol
    */
    placeSymbol(X, NewY, Board, AuxBoard, [], Symbol),
    placeSymbol(X, Y, AuxBoard, ResultingBoard, [], empty).

moveXYAxis(X, Y, Steps, Board, ResultingBoard, Symbol) :- 
    NewX is X+Steps,
    NewY is Y+Steps,
    NewX >= 0, NewX =< 7, 
    NewY >= 0, NewY =< 7,
    placeSymbol(NewX, NewY, Board, AuxBoard, [], Symbol),
    placeSymbol(X, Y, AuxBoard, ResultingBoard, [], empty).

/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */

placeSymbol(_, _, [], Acc, Acc, _).

placeSymbol(X, 0, [Row | RemainingBoard], ResultingBoard, Acc, Symbol) :-
    placeInRow(X, Row, NewRow, Symbol), !,
    append(Acc, [NewRow], NewAcc),
    append(NewAcc, RemainingBoard, FinalAcc),
    placeSymbol(X, 0, [], ResultingBoard, FinalAcc, Symbol).

placeSymbol(X, Y, [Row | RemainingBoard], ResultingBoard, Acc, Symbol) :-
    NewY is Y - 1,
    append(Acc, [Row], NewAcc),
    placeSymbol(X, NewY, RemainingBoard, ResultingBoard, NewAcc, Symbol).

/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */

placeInRow(Idx, Row, ResultRow, Symbol):- placeInRow(Idx, Row, ResultRow, [], Symbol).

placeInRow(_, [], Acc, Acc, _).
placeInRow(0, [_|T], Row, Acc, Symbol):-
    append(Acc, [Symbol], NewAcc),
    append(NewAcc, T, FinalAcc),
    placeInRow(0, [], Row, FinalAcc, Symbol), !.

placeInRow(Idx, [H|T], Row, Acc, Symbol):- 
    NewIdx is Idx-1,
    append(Acc, [H], NewAcc),
    placeInRow(NewIdx, T, Row, NewAcc, Symbol).
