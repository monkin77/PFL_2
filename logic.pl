/* --------------------------------------------------------------- */
% initialBoard

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

testBoard([
[ninja,ninja,ninja,ninja,ninja,ninja,ninja,ninja],
[empty,empty,empty,empty,empty,empty,empty,empty],
[samurai,samurai,samurai,samurai,samurai,samurai,samurai,samurai]
]).

/* --------------------------- Utils ----------------------------- */
/* Players */
:-dynamic piece/2.

/* Pass turn to next player */
next_player(Board-1, Board-2).
next_player(Board-2, Board-1). 

/* Decrement absolute value */
decrementAbs(Val, NewVal) :-
    AbsVal is abs(Val),
    IncVal is Val div AbsVal,
    NewVal is Val-IncVal.

/* Min */
minimum(X1, X2, X3) :-
    X1 =< X2, !, X3 = X1.
minimum(_, X2, X2). 

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
isInRowIndex(0, [Symbol | _], Symbol) :- !. 
isInRowIndex(0, [_ | _], _):- !, fail.
isInRowIndex(_, [], _):- fail.

isInRowIndex(X, [_ | T], Symbol):-
    X > 0, NewX is X-1,
    !, isInRowIndex(NewX, T, Symbol).

/* ------------------------Validation----------------------------- */

/* ------------------------ MAIN isValidMove --------------------- */
isValidMove(Board-Player, Row/Col/StepsX/_/hor) :-
    piece(Player, Symbol), 
    isValidMove(Col, Row, StepsX, hor, Board, Symbol).

isValidMove(Board-Player, Row/Col/_/StepsY/vert) :-
    piece(Player, Symbol), 
    isValidMove(Col, Row, StepsY, vert, Board, Symbol).

isValidMove(Board-Player, Row/Col/StepsX/StepsY/diag) :-
    piece(Player, Symbol), 
    isValidMove(Col, Row, StepsX, StepsY, diag, Board, Symbol).

/*  Last Argument: 0 -> NotFoundAlly   1 -> FoundMovingPiece    2 -> Found Ally  */ 

/* Horizontal  */
clearPrefix(0, Steps, hor, Row, Symbol) :- !, validateTrajectory(Steps, Row, Symbol, 0).
clearPrefix(_, _, hor, [], _) :- !, fail.
clearPrefix(X, Steps, hor, [_ | T], Symbol) :-
    NewX is X-1,
    clearPrefix(NewX, Steps, hor, T, Symbol).

isValidMove(X, 0, Steps, hor, [Row | _], Symbol) :-
    Steps >= 0, !,
    clearPrefix(X, Steps, hor, Row, Symbol).

isValidMove(X, 0, Steps, hor, [Row | _], Symbol) :-
    NewSteps is abs(Steps),
    reverse(Row, RevRow),
    NewX is 7-X,
    clearPrefix(NewX, NewSteps, hor, RevRow, Symbol).

isValidMove(X, Y, Steps, hor, [_ | RemainingBoard], Symbol) :-
    NewY is Y-1,
    !, isValidMove(X, NewY, Steps, hor, RemainingBoard, Symbol).

/* Vertical */
isValidMove(X, Y, Steps, vert, Board, Symbol) :-
    !, transpose(Board, NewBoard),
    isValidMove(Y, X, Steps, hor, NewBoard, Symbol).

/* Diagonal */
/* StepsY < 0 -> Yi is Y+StepsY, Xi is X+StepsX, StepsY is abs(StepsY), StepsX is -StepsX */
isValidMove(X, Y, StepsX, StepsY, diag, Board, Symbol) :-   /* This might return reversed? */
    StepsY < 0, !, NewStepsY is abs(StepsY), NewY is Y-NewStepsY, NewStepsX is -StepsX, NewX is X+StepsX,
    getDiagonal(NewX, NewY, NewStepsX, NewStepsY, diag, Board, [], Trajectory),
    reverse(Trajectory, NewTrajectory),
    AbsX is abs(StepsX),
    validateTrajectory(AbsX, NewTrajectory, Symbol, 0).
isValidMove(X, Y, StepsX, StepsY, diag, Board, Symbol) :-
    !, StepsY >= 0,
    getDiagonal(X, Y, StepsX, StepsY, diag, Board, [], Trajectory),
    AbsX is abs(StepsX),
    validateTrajectory(AbsX, Trajectory, Symbol, 0).

/* Iterate Matrix to find diagonal */
getDiagonal(X, 0, _, 0, diag, [Row | _], Acc, Trajectory) :- /* Base case */
    !, isInRowIndex(X, Row, CurrSymbol),    /* Get Symbol from this Row */
    append(Acc, [CurrSymbol], NewAcc),
    Trajectory = NewAcc.

getDiagonal(X, 0, StepsX, StepsY, diag, [Row | RemainingBoard], Acc, Trajectory) :- /* Check if needs cuts */
    isInRowIndex(X, Row, CurrSymbol),    /* Get Symbol from this Row */
    append(Acc, [CurrSymbol], NewAcc),
    AbsX is abs(StepsX),
    IncX is StepsX div AbsX,
    NewX is X+IncX,
    NewStepsX is StepsX-IncX,
    NewStepsY is StepsY-1,
    !, getDiagonal(NewX, 0, NewStepsX, NewStepsY, diag, RemainingBoard, NewAcc, Trajectory).

getDiagonal(X, Y, StepsX, StepsY, diag, [_ | RemainingBoard], Acc, Trajectory) :-
    NewY is Y-1,
    getDiagonal(X, NewY, StepsX, StepsY, diag, RemainingBoard, Acc, Trajectory).

    

/* Acceptance states (After flattening trajectory into a row) */
validateTrajectory(_, [], _, _) :- !, fail.
validateTrajectory(_,_,_,3) :- !, fail.  /* if it finds 2 allies */
validateTrajectory(0, [empty | _], _, AllyCount) :-
    !, AllyCount < 2.
validateTrajectory(0, [Symbol | _], Symbol, _) :-
    !, fail.
validateTrajectory(0, [_ | _], _, AllyCount) :-
    !, AllyCount =:= 2.

validateTrajectory(Steps, [Symbol | RemainingRow], Symbol, AllyCount) :-
    AllyCount < 2, NewAllyCount is AllyCount+1,
    NewSteps is Steps - 1,
    !, validateTrajectory(NewSteps, RemainingRow, Symbol, NewAllyCount).
validateTrajectory(Steps, [empty | RemainingRow], Symbol, AllyCount) :-
    AllyCount =< 2,
    NewSteps is Steps - 1,
    !, validateTrajectory(NewSteps, RemainingRow, Symbol, AllyCount).   /* Investigate the need of this cuts*/
validateTrajectory(_, _, _, _) :-     /* enemy symbol*/
    !, fail.

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
    placeSymbol(X, NewY, Board, AuxBoard, [], Symbol),
    placeSymbol(X, Y, AuxBoard, ResultingBoard, [], empty).


/* Function to move a Symbol Steps positions in diagonal */
moveXYAxis(X, Y, StepsX, StepsY, Board, ResultingBoard, Symbol) :- 
    NewX is X+StepsX,
    NewY is Y+StepsY,
    NewX >= 0, NewX =< 7, 
    NewY >= 0, NewY =< 7,
    placeSymbol(NewX, NewY, Board, AuxBoard, [], Symbol),
    placeSymbol(X, Y, AuxBoard, ResultingBoard, [], empty).

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

/* ----------------------- Evaluate Game --------------------------- */
countPiecesInRow(Row, NinjaCount, SamuraiCount) :- countPiecesInRow(Row, NinjaCount, SamuraiCount, 0, 0), !.

countPiecesInRow([], NinjaCount, SamuraiCount, NinjaCount, SamuraiCount) :- !.
countPiecesInRow([ninja | T], NinjaCount, SamuraiCount, Acc1, Acc2) :-
    NewAcc1 is Acc1+1,
    countPiecesInRow(T, NinjaCount, SamuraiCount, NewAcc1, Acc2).
countPiecesInRow([samurai | T], NinjaCount, SamuraiCount, Acc1, Acc2) :-
    NewAcc2 is Acc2+1,
    countPiecesInRow(T, NinjaCount, SamuraiCount, Acc1, NewAcc2).
countPiecesInRow([_ | T], NinjaCount, SamuraiCount, Acc1, Acc2) :-
    countPiecesInRow(T, NinjaCount, SamuraiCount, Acc1, Acc2).

/* --------------------------------------------------------------- */

countBoardPieces(Board, NinjaCount, SamuraiCount) :-
    countBoardPieces(Board, NinjaCount, SamuraiCount, 0, 0).

countBoardPieces([], NinjaAcc, SamuraiAcc, NinjaAcc, SamuraiAcc).
countBoardPieces([Row | RemainingBoard], NinjaCount, SamuraiCount, NinjaAcc, SamuraiAcc) :-
    countPiecesInRow(Row, RowNinjaCount, RowSamuraiCount),
    NewNinjaCount is NinjaAcc + RowNinjaCount,
    NewSamuraiCount is SamuraiAcc + RowSamuraiCount,
    countBoardPieces(RemainingBoard, NinjaCount, SamuraiCount, NewNinjaCount, NewSamuraiCount).

/* --------------------------------------------------------------- */
% (Board, Player, Value)
value(Board, Player, Value) :-
    piece(Player, Symbol),
    Symbol = samurai, !,
    countBoardPieces(Board, NinjaCount, SamuraiCount),
    Value is SamuraiCount - NinjaCount.

value(Board, Player, Value) :-
    piece(Player, Symbol),
    Symbol = ninja, !,
    countBoardPieces(Board, NinjaCount, SamuraiCount),
    Value is NinjaCount - SamuraiCount.
    

/* ------------------------- Game Over ----------------------------- */
game_over(Board-Player, Winner) :-
    isEndGame(Board), !,
    next_player(Board-Player, Board-Winner).

isEndGame(Board) :- 
    countBoardPieces(Board, NinjaCount, SamuraiCount), !,
    (NinjaCount =< 4; SamuraiCount =< 4).

/* --------------------------------------------------------------- */

move(Board-Player, StartRow/StartCol/StepsX/_/hor, NewGameState):-
    piece(Player, P),
    moveXAxis(StartCol, StartRow, StepsX, Board, NewBoard, P),
    NewGameState = NewBoard-Player.

move(Board-Player, StartRow/StartCol/_/StepsY/vert, NewGameState):-
    piece(Player, P),
    moveYAxis(StartCol, StartRow, StepsY, Board, NewBoard, P),
    NewGameState = NewBoard-Player.

move(Board-Player, StartRow/StartCol/StepsX/StepsY/diag, NewGameState):-
    piece(Player, P),
    moveXYAxis(StartCol, StartRow, StepsX, StepsY, Board, NewBoard, P),
    NewGameState = NewBoard-Player.

/* ----------------------- Armies --------------------------- */
/* Add methods that identify each player number to its piece and define the starting player */
manageArmies(samurai, StartingPlayer) :-
    assertz( ( piece(1, Symbol) :- Symbol = samurai ) ),
    assertz( ( piece(2, Symbol) :- Symbol = ninja ) ),
    StartingPlayer = 1.

manageArmies(ninja, StartingPlayer) :-
    assertz( ( piece(1, Symbol) :- Symbol = ninja ) ),
    assertz( ( piece(2, Symbol) :- Symbol = samurai ) ),
    StartingPlayer = 2.
