:-use_module(library(lists)).

initialBoard([
[empty,ninja,ninja,ninja,ninja,empty,empty,ninja],
[empty,samurai,empty,ninja,empty,empty,ninja,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[samurai,samurai,samurai,samurai,samurai,samurai,samurai,samurai]
]).

/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */

/* Function to check if a Symbol is in position X Y of the Board */
isInCell(X, 0, [Row | _], Symbol):-
    !, isInRowIndex(X, Row, Symbol).

isInCell(X, Y, [_ | RemainingBoard], Symbol):-
    X >= 0,
    Y >= 0,
    NewY is Y-1,
    isInCell(X, NewY, RemainingBoard, Symbol).

/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */

/* Function that checks if the row has the element Symbol in position X*/
isInRowIndex(0, [Symbol | _], Symbol). 
isInRowIndex(0, [_ | _], _):- !, fail.
isInRowIndex(_, [], _):- fail.

isInRowIndex(X, [_ | T], Symbol):-
    NewX is X-1,
    isInRowIndex(NewX, T, Symbol).

/* ------------------------Validation----------------------------- */
/*  Last Argument: 0 -> NotFoundAlly   1 -> FoundMovingPiece    2 -> Found Ally  */ 

/* Horizontal  */
clearPrefix(0, Steps, hor, Row, Symbol) :- !, isValidMove(Steps, hor, Row, Symbol, 0).
clearPrefix(_, _, hor, [], _) :- !, fail.
clearPrefix(X, Steps, hor, [_ | T], Symbol) :-
    NewX is X-1,
    clearPrefix(NewX, Steps, hor, T, Symbol).

isValidMove(X, 0, Steps, hor, [Row | _], Symbol) :-
    Steps >= 0,
    clearPrefix(X, Steps, hor, Row, Symbol).

isValidMove(X, 0, Steps, hor, [Row | _], Symbol) :-
    NewSteps is abs(Steps),
    reverse(Row, RevRow),
    NewX is 7-X,
    clearPrefix(NewX, NewSteps, hor, RevRow, Symbol).

isValidMove(X, Y, Steps, hor, [_ | RemainingBoard], Symbol) :-
    NewY is Y-1,
    !, isValidMove(X, NewY, Steps, hor, RemainingBoard, Symbol).

/* isValidMove(X, 0, ) */
isValidMove(_, hor, [], _, _) :- !, fail.

/* Acceptance states */
isValidMove(_,_,_,_,3) :- !, fail.  /* if it finds 2 allies */
isValidMove(0, hor, [empty | _], _, AllyCount) :-
    !, AllyCount < 2.
isValidMove(0, hor, [Symbol | _], Symbol, _) :-
    !, fail.
isValidMove(0, hor, [_ | _], _, AllyCount) :-
    !, AllyCount =:= 2.

isValidMove(Steps, hor, [Symbol | RemainingRow], Symbol, AllyCount) :-
    AllyCount < 2, NewAllyCount is AllyCount+1,
    NewSteps is Steps - 1,
    !, isValidMove(NewSteps, hor, RemainingRow, Symbol, NewAllyCount).
isValidMove(Steps, hor, [empty | RemainingRow], Symbol, AllyCount) :-
    AllyCount =< 2,
    NewSteps is Steps - 1,
    !, isValidMove(NewSteps, hor, RemainingRow, Symbol, AllyCount).   /* Investigate the need of this cuts*/
isValidMove(_, _, _, _, _) :-     /* enemy symbol*/
    !, fail.

/* isValidMove(X, Steps, hor, [Symbol | RemainingRow], Symbol, notFoundAlly) :- */

/* Vertical */ 

/* isValidMove(X, Y, Steps, vert, [Row | RemainingBoard]) :-
isValidMove(X, Y, Steps, diag, [Row | RemainingBoard]) :- */

/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */

/* Function to move a Symbol Steps positions horizontally */
moveXAxis(X, Y, Steps, Board, ResultingBoard, Symbol) :-
    NewX is X + Steps,
    NewX >= 0,
    NewX =< 7,
    placeSymbol(NewX, Y, Board, AuxBoard, [], Symbol),
    placeSymbol(X, Y, AuxBoard, ResultingBoard, [], empty). /* place empty symbol in the position the element was */

/* Function to move a Symbol Steps positions vertically */
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


/* Function to move a Symbol Steps positions in diagonal */
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

/* --------------------------------------------------------------- */
