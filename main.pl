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

placeEmpty(X, Y, Board):- placeEmpty(X, Y, 0, 0, Board).

placeEmpty(X, 0, currX, currY, [H|T]):-
    placeInRow(X, 0, H).

placeEmpty(X, Y, currX, currY, [H|T]).
*/

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
