:- consult('menus.pl').
:- consult('logic.pl').
:- consult('display.pl').
:- consult('input.pl').

/* Move -> startRow/startCol/StepsX/StepsY/Direction */
/* GameState = Board-Player. Player -> 1 | 2 */
initial_state(Board-Player):-
    initialBoard(Board),
    Player = 1.

play_game(Opponent):-
    initial_state(GameState),
    display_game(GameState),
    game_cycle(GameState, Opponent).
    
game_cycle(GameState, Opponent) :-
    choose_move(GameState, Opponent, Move),
    move(GameState, Move, UpdatedGameState),
    next_player(UpdatedGameState, NewGameState),
    display_game(NewGameState),
    game_cycle(NewGameState, Opponent).

play :- mainMenu.

