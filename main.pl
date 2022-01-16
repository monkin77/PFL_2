:- consult('logic.pl').
:- consult('display.pl').
:- consult('input.pl').

/* Move -> startRow/startCol/StepsX/StepsY/Direction */

/* Change GameState-Player to GameState = Board-Player */
initial_state(Board-Player):-
    initialBoard(Board),
    Player = 1.

play_game:-
    initial_state(GameState),
    display_game(GameState),

    choose_move(GameState, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState).
    /*game_cycle(GameState-Player).*/

