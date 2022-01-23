showError(Message) :-
    write(Message), fail.
/* --------------------------------------------------------------- */
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

isPlayerPiece(Board, Row, Column, Player):-
    piece(Player, Symbol),
    isInCell(Column, Row, Board, Symbol), !.

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
checkPlayerMove(Board-Player, CurrMove) :-
    isValidMove(Board-Player, CurrMove), !.

checkPlayerMove(_, _) :- showError('Invalid move! Please try again.\n\n').

/* --------------------------------------------------------------- */
choose_move(Board-Player, human, Move) :-
    printCurrentPlayer(Board, Player), !, 
    repeat, 
    write('Choose the piece you want to move\n'),
    getCoords(StartRow, StartCol),
    isPlayerPiece(Board, StartRow, StartCol, Player),
    write('Choose the cell you want to move towards\n'),
    getCoords(EndRow, EndCol),
    parseMove(StartRow/StartCol, EndRow/EndCol, Direction, StepsX, StepsY),
    CurrMove = StartRow/StartCol/StepsX/StepsY/Direction,
    checkPlayerMove(Board-Player, CurrMove),
    !, Move = CurrMove.

% P1 turn against a bot
choose_move(Board-1, computer-_, Move) :-
    !, choose_move(Board-1, human, Move).

% Bot turn against a player or Bot V.S Bot (computer-2)
choose_move(Board-Player, _-Level, Move) :-
    printCurrentPlayer(Board, Player), !, 
    sleep(1),
    valid_moves(Board-Player, Moves),
    choose_move(Level, Board-Player, Moves, Move).

/* --------------------------------------------------------------- */
choose_move(easy, _GameState, Moves, Move) :-
    !, random_select(Move, Moves, _Rest).

% Hard Mode
choose_move(_, Board-Player, Moves, Move) :-
    value(Board, Player, OldVal),
    findBestMove(Board-Player, OldVal, Moves, Move), !.

choose_move(_, _GameState, Moves, Move) :-
    !, random_select(Move, Moves, _Rest).

/* --------------------------------------------------------------- */
findBestMove(Board-Player, OldVal, [CurrMove | _], Move) :-
    move(Board-Player, CurrMove, NewBoard-_),
    value(NewBoard, Player, NewVal),
    NewVal > OldVal, !,
    Move = CurrMove.

% If current move is not optimal
findBestMove(GameState, OldVal, [_ | Moves], Move) :-
    findBestMove(GameState, OldVal, Moves, Move).
