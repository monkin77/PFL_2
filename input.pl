/* --------------------------------------------------------------- */

getRow(Row):-
    write('Row -> '),
    read(Row).

/* --------------------------------------------------------------- */

getColumn(Column):-
    write('Column -> '),
    read(Column),
    nl.

/* --------------------------------------------------------------- */

getCoords(Row, Column):-
    getRow(AuxRow), getColumn(AuxColumn),
    AuxRow > 0, AuxRow < 9, AuxColumn > 0, AuxColumn < 9,
    Row is AuxRow - 1, Column is AuxColumn - 1.

/* --------------------------------------------------------------- */

isPlayerPiece(GameState, Row, Column, 1):-
    isInCell(Column, Row, GameState, samurai).
isPlayerPiece(GameState, Row, Column, 2):-
    isInCell(Column, Row, GameState, ninja).

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
    parseDirection(StepsX, StepsY, Direction),
    RetStepsX is StepsX, 
    RetStepsY is StepsY.

/* --------------------------------------------------------------- */

choose_move(GameState, Player, Move):-
    write('Choose the piece you want to move\n'),
    getCoords(StartRow, StartCol),
    isPlayerPiece(GameState, StartRow, StartCol, Player),
    getCoords(EndRow, EndCol),
    parseMove(StartRow/StartCol, EndRow/EndCol, Direction, StepsX, StepsY),
    Move = StartRow/StartCol/StepsX/StepsY/Direction.

