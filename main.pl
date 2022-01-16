:- consult('logic.pl').
:- consult('display.pl').
:- consult('input.pl').

/* Move -> startRow/startCol/StepsX/StepsY/Direction */

/* Change GameState-Player to GameState = Board-Player */
initial_state(GameState-Player):-
    initialBoard(GameState),
    Player = 1.

play_game:-
    initial_state(GameState-Player),
    display_game(GameState-Player),

    choose_move(GameState, Player, Move),
    move(GameState-Player, Move, NewGameState),
    display_game(NewGameState).
    /*game_cycle(GameState-Player).*/

