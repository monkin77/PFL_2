showError(Message) :-
    write(Message), fail.
/* --------------------------------------------------------------- */
between(Min, Max, Val) :-
    Min =< Val,
    Max >= Val.

read_number(X) :- read_number(X, 0).

/* Base Case: If we reach a Line Feed, stop reading  */
read_number(X, X) :- peek_code(10), !, skip_line.
/* read_number(X, X) :- peek_code(13), !, skip_line. */

read_number(X, Acc) :-
    get_code(D),
    char_code('0', Z),
    Num is D - Z,
    Num >= 0, Num =< 9, !,  /* Validates the input only contains digits  */
    Next is Acc*10 + Num,
    read_number(X, Next).

read_until_between(Min, Max, X) :-
    repeat, read_number(X), between(Min, Max, X), !.

/* --------------------------------------------------------------- */

getRow(Row):-
    write('Row -> '),
    read_until_between(1, 8, Row).

/* --------------------------------------------------------------- */

getColumn(Column):-
    write('Column -> '),
    read_until_between(1, 8, Column),
    nl.

/* --------------------------------------------------------------- */

getCoords(Row, Column):-
    getRow(AuxRow), getColumn(AuxColumn),
    AuxRow > 0, AuxRow < 9, AuxColumn > 0, AuxColumn < 9, !,
    Row is AuxRow - 1, Column is AuxColumn - 1.

getCoords(_, _) :-
    showError('Invalid coordinates provided! Please try again.\n\n').

/* --------------------------------------------------------------- */

isPlayerPiece(GameState, Row, Column, 1):-
    isInCell(Column, Row, GameState, samurai), !.
isPlayerPiece(GameState, Row, Column, 2):-
    isInCell(Column, Row, GameState, ninja), !.

isPlayerPiece(_, _, _, _) :-
    showError('That cell does not contain one of your pieces! Please try again.\n\n').

/* --------------------------------------------------------------- */

parseDirection(0, _, Direction):-  Direction = vert.
parseDirection(_, 0, Direction):- Direction = hor.
parseDirection(StepsX, StepsY, Direction):-
    ModStepsX is abs(StepsX),
    ModStepsY is abs(StepsY),
    ModStepsX =:= ModStepsY,
    Direction = diag.

parseMove(StartRow/StartCol, EndRow/EndCol, Direction, RetStepsX, RetStepsY):-
    StepsX is EndCol - StartCol, StepsY is EndRow - StartRow,
    parseDirection(StepsX, StepsY, Direction), !,
    RetStepsX is StepsX, 
    RetStepsY is StepsY.

parseMove(_, _, _, _, _) :- 
    showError('Invalid move! Please try again.\n\n').

/* --------------------------------------------------------------- */


choose_move(Board-Player, human, Move):-
    repeat,
    write('Choose the piece you want to move\n'),
    getCoords(StartRow, StartCol),
    isPlayerPiece(Board, StartRow, StartCol, Player),
    write('Choose the cell you want to move towards\n'),
    getCoords(EndRow, EndCol),
    parseMove(StartRow/StartCol, EndRow/EndCol, Direction, StepsX, StepsY),
    !, Move = StartRow/StartCol/StepsX/StepsY/Direction.

choose_move(Board-1, computer-_, Move).

choose_move(Board-2, computer-Level, Move).

