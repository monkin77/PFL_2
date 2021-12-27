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
placeInRow(Idx, Row, ResultRow):- placeInRow(Idx, Row, ResultRow, []).

placeInRow(_, [], Acc, Acc).
placeInRow(0, [_|T], Row, Acc):-
    append(Acc, [samurai], NewAcc),
    append(NewAcc, T, FinalAcc),
    placeInRow(0, [], Row, FinalAcc).

placeInRow(Idx, [H|T], Row, Acc):- 
    NewIdx is Idx-1,
    append(Acc, [H], NewAcc),
    placeInRow(NewIdx, T, Row, NewAcc).
/* --------------------------------------------------------------- */


/* --------------------------------------------------------------- */
moveXAxis(X, Y, Steps, Board, ResultingBoard) :-
    /* Verificar se X e Y estão entre 0 e 7, se a posição aonde colocar está empty
    e retirar o elemento(para ja e um samurai) da sua posição inicial*/
    NewX is X + Steps,
    NewX >= 0,
    NewX =< 7,
    moveXAxis(X, Y, Steps, Board, ResultingBoard, []).

moveXAxis(_, _, _, [], Acc, Acc).
moveXAxis(X, 0, Steps, [Row | RemainingBoard], ResultingBoard, Acc) :-
    PositionInRow is X + Steps,
    placeInRow(PositionInRow, Row, NewRow),
    append(Acc, [NewRow], NewAcc),
    append(NewAcc, RemainingBoard, FinalAcc),
    moveXAxis(X, 0, Steps, [], ResultingBoard, FinalAcc).

moveXAxis(X, Y, Steps, [Row | RemainingBoard], ResultingBoard, Acc) :- 
    NewY is Y-1,
    append(Acc, [Row], NewAcc),
    moveXAxis(X, NewY, Steps, RemainingBoard, ResultingBoard, NewAcc).
/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */
moveYAxis(X, Y, Steps, Board, ResultingBoard) :- 
    NewY is Y + Steps,
    NewY >= 0,
    NewY =< 7,
    /* Verificar se X e Y estão entre 0 e 7, se a posição aonde colocar está empty
    e retirar o elemento(para ja e um samurai) da sua posição inicial*/
    placeInColumn(X, NewY, Board, ResultingBoard, []).


placeInColumn(_, _, [], Acc, Acc).
placeInColumn(X, 0, [Row |RemainingBoard], ResultingBoard, Acc):-
    placeInRow(X, Row, NewRow),
    append(Acc, [NewRow], NewAcc),
    append(NewAcc, RemainingBoard, FinalAcc),
    placeInColumn(X, 0, [], ResultingBoard, FinalAcc).

placeInColumn(X, Y, [Row | RemainingBoard], ResultingBoard, Acc):-
    NewY is Y - 1,
    append(Acc, [Row], NewAcc),
    placeInColumn(X, NewY, RemainingBoard, ResultingBoard, NewAcc).
/* --------------------------------------------------------------- */
