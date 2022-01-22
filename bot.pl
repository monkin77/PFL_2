/* --------------------------  Bot  -----------------------------  */
/* 
ALGORITHM TO GET VALID MOVES:
- Iterate Board to find each player piece
- For each piece, attempt to move in every direction (hor, vert, diag) with any number of StepsX and StepsY in the range inside the board
- In the vertical move, we have to find the minimum absolute step to match X and Y
- For every valid move, push it to an accumulator and backtrack (regression algorithm)
*/
valid_moves(Board-Player, Moves) :-
    piece(Player, Symbol),
    findMoves(Board-Player, Board, Symbol, 0, Moves, []).

/* --------------------------------------------------------------- */
findMoves(_, [], _, _, Acc, Acc).

findMoves(GameState, [Row | RemainingBoard], Symbol, Y, Moves, Acc) :-
    findMovesRow(GameState, Row, Symbol, 0, Y, RowMoves, []),
    append(Acc, RowMoves, NewMoves),
    NewY is Y + 1,
    findMoves(GameState, RemainingBoard, Symbol, NewY, Moves, NewMoves).

/* --------------------------------------------------------------- */

findMovesRow(_, [], _, _, _, Acc, Acc).

findMovesRow(GameState, [Symbol | RemainingRow], Symbol, X, Y, RowMoves, Acc) :-
    !, NumRight is 7-X, NumLeft is -X,
    NumTop is -Y, NumBottom is 7-Y,

    findMovesRange(GameState, X, Y, NumLeft, hor, LeftMoves, Acc),
    findMovesRange(GameState, X, Y, NumRight, hor, RightMoves, LeftMoves),

    findMovesRange(GameState, X, Y, NumTop, vert, TopMoves, RightMoves),
    findMovesRange(GameState, X, Y, NumBottom, vert, BottomMoves, TopMoves),

    handleDiagRange(GameState, X, Y, NumLeft, NumTop, diag, TopLeft, BottomMoves),
    handleDiagRange(GameState, X, Y, NumLeft, NumBottom, diag, BottomLeft, TopLeft),
    handleDiagRange(GameState, X, Y, NumRight, NumTop, diag, TopRight, BottomLeft),
    handleDiagRange(GameState, X, Y, NumRight, NumBottom, diag, NewAcc, TopRight),

    NewX is X+1,
    findMovesRow(GameState, RemainingRow, Symbol, NewX, Y, RowMoves, NewAcc).

findMovesRow(GameState, [_ | RemainingRow], Symbol, X, Y, RowMoves, Acc) :-
    NewX is X+1,
    findMovesRow(GameState, RemainingRow, Symbol, NewX, Y, RowMoves, Acc).

/* --------------------------------------------------------------- */
/* Find all valid moves of a piece in a certain direction */
% Hor and Vert base case
findMovesRange(_, _, _, 0, _, Acc, Acc) :- !.

findMovesRange(GameState, X, Y, StepsX, hor, RowMoves, Acc) :-
    Move = Y/X/StepsX/0/hor,
    isValidMove(GameState, Move), !,
    append(Acc, [Move], NewAcc),
    decrementAbs(StepsX, NewStepsX),
    findMovesRange(GameState, X, Y, NewStepsX, hor, RowMoves, NewAcc).
% If Horizontal move fails
findMovesRange(GameState, X, Y, StepsX, hor, RowMoves, Acc) :-
    decrementAbs(StepsX, NewStepsX),
    findMovesRange(GameState, X, Y, NewStepsX, hor, RowMoves, Acc).

findMovesRange(GameState, X, Y, StepsY, vert, RowMoves, Acc) :-
    Move = Y/X/0/StepsY/vert,
    isValidMove(GameState, Move), !,   % cut here  ??
    append(Acc, [Move], NewAcc),
    decrementAbs(StepsY, NewStepsY),
    findMovesRange(GameState, X, Y, NewStepsY, vert, RowMoves, NewAcc).
% If Vertical move fails
findMovesRange(GameState, X, Y, StepsY, vert, RowMoves, Acc) :-
    decrementAbs(StepsY, NewStepsY),
    findMovesRange(GameState, X, Y, NewStepsY, vert, RowMoves, Acc).

% diag base case
findMovesRange(_, _, _, 0, 0, diag, Acc, Acc) :- !.

findMovesRange(GameState, X, Y, StepsX, StepsY, diag, RowMoves, Acc) :-
    Move = Y/X/StepsX/StepsY/diag,
    isValidMove(GameState, Move), !,
    append(Acc, [Move], NewAcc),
    decrementAbs(StepsX, NewStepsX), decrementAbs(StepsY, NewStepsY),
    findMovesRange(GameState, X, Y, NewStepsX, NewStepsY, diag, RowMoves, NewAcc).
%If Diagonal move fails
findMovesRange(GameState, X, Y, StepsX, StepsY, diag, RowMoves, Acc) :-
    decrementAbs(StepsX, NewStepsX), decrementAbs(StepsY, NewStepsY),
    findMovesRange(GameState, X, Y, NewStepsX, NewStepsY, diag, RowMoves, Acc).

handleDiagRange(GameState, X, Y, StepsX, StepsY, diag, RowMoves, Acc) :-
    calcMaxDiagSteps(StepsX, StepsY, NewStepsX, NewStepsY), !,
    findMovesRange(GameState, X, Y, NewStepsX, NewStepsY, diag, RowMoves, Acc).

% If calcMaxDiagSteps Fails (Minimum <= 0)
handleDiagRange(_, _, _, _, _, _, Acc, Acc).

calcMaxDiagSteps(StepsX, StepsY, NewStepsX, NewStepsY) :-
    AbsX is abs(StepsX), AbsY is abs(StepsY),
    minimum(AbsX, AbsY, Minimum),
    Minimum > 0,
    IncX is StepsX div AbsX, IncY is StepsY div AbsY,
    NewStepsX is Minimum * IncX, NewStepsY is Minimum * IncY.