initialBoard([
[ninja,ninja,ninja,ninja,ninja,ninja,ninja,ninja],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[samurai,samurai,samurai,samurai,samurai,samurai,samurai, samurai]
]).

/*
moveUp(X, Y, Steps, Board):-
    placeEmpty(X, Y, Board).
*/

/*
placeEmpty(X, Y, Board):- placeEmpty(X, Y, 0, 0, Board).

placeEmpty(X, 0, currX, currY, [H|T]):-
    placeInRow(X, 0, H).

placeEmpty(X, Y, currX, currY, [H|T]).
*/


/* --------------------------------------------------------------- */
placeInRow(Idx, Row, ResultRow, Symbol):- placeInRow(Idx, Row, ResultRow, [], Symbol).

placeInRow(_, [], Acc, Acc, _).
placeInRow(0, [_|T], Row, Acc, Symbol):-
    append(Acc, [Symbol], NewAcc),
    append(NewAcc, T, FinalAcc),
    placeInRow(0, [], Row, FinalAcc, Symbol).

placeInRow(Idx, [H|T], Row, Acc, Symbol):- 
    NewIdx is Idx-1,
    append(Acc, [H], NewAcc),
    placeInRow(NewIdx, T, Row, NewAcc, Symbol).
/* --------------------------------------------------------------- */


/* --------------------------------------------------------------- */
moveXAxis(X, Y, Steps, Board, ResultingBoard, Symbol) :-
    /* Verificar se X e Y estão entre 0 e 7, se a posição aonde colocar está empty
    e retirar o elemento(para ja e um samurai) da sua posição inicial*/
    NewX is X + Steps,
    NewX >= 0,
    NewX =< 7,
    moveXAxis(X, Y, Steps, Board, ResultingBoard, [], Symbol).

moveXAxis(_, _, _, [], Acc, Acc, _).
moveXAxis(X, 0, Steps, [Row | RemainingBoard], ResultingBoard, Acc, Symbol) :-
    PositionInRow is X + Steps,
    placeInRow(PositionInRow, Row, NewRow, Symbol),
    append(Acc, [NewRow], NewAcc),
    append(NewAcc, RemainingBoard, FinalAcc),
    moveXAxis(X, 0, Steps, [], ResultingBoard, FinalAcc, Symbol).

moveXAxis(X, Y, Steps, [Row | RemainingBoard], ResultingBoard, Acc, Symbol) :- 
    NewY is Y-1,
    append(Acc, [Row], NewAcc),
    moveXAxis(X, NewY, Steps, RemainingBoard, ResultingBoard, NewAcc, Symbol).
/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */
moveYAxis(X, Y, Steps, Board, ResultingBoard, Symbol) :- 
    NewY is Y + Steps,
    NewY >= 0,
    NewY =< 7,
    /* TO DO
    verificar se a posição aonde colocar está empty
    verificar se o elemento na posicao inicial é igual ao symbol
    */
    placeInColumn(X, NewY, Board, AuxBoard, [], Symbol),
    placeInColumn(X, Y, AuxBoard, ResultingBoard, [], empty).

placeInColumn(_, _, [], Acc, Acc, _).
placeInColumn(X, 0, [Row |RemainingBoard], ResultingBoard, Acc, Symbol):-
    placeInRow(X, Row, NewRow, Symbol),
    append(Acc, [NewRow], NewAcc),
    append(NewAcc, RemainingBoard, FinalAcc),
    placeInColumn(X, 0, [], ResultingBoard, FinalAcc, Symbol).

placeInColumn(X, Y, [Row | RemainingBoard], ResultingBoard, Acc, Symbol):-
    NewY is Y - 1,
    append(Acc, [Row], NewAcc),
    placeInColumn(X, NewY, RemainingBoard, ResultingBoard, NewAcc, Symbol).
/* --------------------------------------------------------------- */
