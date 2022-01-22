:-use_module(library(lists)).
:-use_module(library(between)).
:- use_module(library(random)).

:- consult('menus.pl').
:- consult('logic.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('bot.pl').

/* Move -> startRow/startCol/StepsX/StepsY/Direction */
/* GameState = Board-Player. Player -> 1 | 2 */
initial_state(Board-Player):-
    initialBoard(Board),
    Player = 1.

play_game(GameType):-
    initial_state(GameState),
    display_game(GameState),
    game_cycle(GameState, GameType).
    
game_cycle(GameState, _) :-
    game_over(GameState, Winner), !,
    congratulate(Winner).

game_cycle(GameState, GameType) :-
    choose_move(GameState, GameType, Move),
    move(GameState, Move, UpdatedGameState),
    next_player(UpdatedGameState, NewGameState),
    display_game(NewGameState),
    game_cycle(NewGameState, GameType).

play :- mainMenu.

/*
    - CHECK IF THE SELECTED MOVE IS VALID
    - GET VALID MOVES
    - CHOOSE A MOVE FROM LIST
    - ASK IF WE SHOULD PRINT WHENEVER THERE IS A INVALID INPUT OR IF IT IS ALREADY FINE AS IS
*/
