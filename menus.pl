mainMenu :-
    showMainMenu,
    getOption.

/* --------------------------------------------------------------- */

getOption :-
    write('Insert an option -> '),
    read_until_between(0, 3, Option),
    handleOption(Option).

getLevel(Players) :- 
    write('Insert level -> '),
    read_until_between(0, 2, Option),
    handleLevel(Players, Option).

/* --------------------------------------------------------------- */
handleLevel(_, 0):-
    mainMenu.
    
handleLevel(player-ai, 1):-
    play_game(computer-easy).

handleLevel(player-ai, 2):-
    play_game(computer-hard).

handleLevel(ai-ai, 1):-
    play_game(computer2-easy).

handleLevel(ai-ai, 2):-
    play_game(computer2-hard).

handleOption(_, _) :-
    write('That is not a valid option!\n\n'),
    getOption.

/* --------------------------------------------------------------- */

handleOption(1) :-
    !, play_game(human).

handleOption(2) :-
    !, showAILevelMenu, getLevel(player-ai).

handleOption(3) :-
    !, showAILevelMenu, getLevel(ai-ai).

handleOption(0) :-
    write('Leaving...\n').

handleOption(_) :-
    write('That is not a valid option!\n\n'),
    getOption.

/* --------------------------------------------------------------- */

/* 40x20 Board */ 
showMainMenu :-
    nl,
    write(' -------------------------------------- \n'),
    write('|                                      |\n'),
    write('|                   Shi                |\n'),
    write('|                                      |\n'),
    write('|              Joao Mesquita           |\n'),
    write('|                Rui Alves             |\n'),
    write('|                                      |\n'),
    write('|           -------------------        |\n'),
    write('|                                      |\n'),
    write('|                                      |\n'),
    write('|          1. Player V.S Player        |\n'),
    write('|                                      |\n'),
    write('|           2. Player V.S AI           |\n'),
    write('|                                      |\n'),
    write('|            3. AI V.S AI              |\n'),
    write('|                                      |\n'),
    write('|              0. Exit                 |\n'),
    write('|                                      |\n'),
    write('|                                      |\n'),
    write(' -------------------------------------- \n'),
    nl.

/* 40x20 Board */ 
showAILevelMenu :-
    nl,
    write(' -------------------------------------- \n'),
    write('|                                      |\n'),
    write('|                   Shi                |\n'),
    write('|                                      |\n'),
    write('|           -------------------        |\n'),
    write('|                                      |\n'),
    write('|                                      |\n'),
    write('|                1. Easy               |\n'),
    write('|                                      |\n'),
    write('|               2. Medium              |\n'),
    write('|                                      |\n'),
    write('|              0. Go Back              |\n'),
    write('|                                      |\n'),
    write('|                                      |\n'),
    write(' -------------------------------------- \n'),
    nl.