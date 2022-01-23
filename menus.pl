mainMenu :-
    showMainMenu,
    getOption.

/* --------------------------------------------------------------- */

getOption :-
    write('Insert an option -> '),
    read_until_between(0, 3, Option),
    handleOption(Option).

handleOption(1) :-
    !, play_game(human, samurai).

handleOption(2) :-
    !, showArmyMenu, getArmy(player-ai). 

handleOption(3) :-
    !, showAILevelMenu, getLevel(ai-ai, samurai).

handleOption(0) :-
    write('Leaving...\n').

handleOption(_) :-
    write('That is not a valid option!\n\n'),
    getOption.

/* --------------------------------------------------------------- */

getLevel(Players, Army) :- 
    write('Insert level -> '),
    read_until_between(0, 2, Option),
    handleLevel(Players, Army, Option).

handleLevel(_, _, 0):-
    !, mainMenu.
    
handleLevel(player-ai, Army, 1):-
    play_game(computer-easy, Army).

handleLevel(player-ai, Army, 2):-
    play_game(computer-hard, Army).

handleLevel(ai-ai, samurai, 1):-
    play_game(computer2-easy, samurai).

handleLevel(ai-ai, samurai, 2):-
    play_game(computer2-hard, samurai).

/* --------------------------------------------------------------- */
getArmy(Players) :- 
    write('Choose your army -> '),
    read_until_between(0, 2, Option),
    handleArmy(Players, Option).

handleArmy(_, 0):-
    !, mainMenu.
    
handleArmy(Players, 1):-
    showAILevelMenu, getLevel(Players, samurai).

handleArmy(Players, 2):-
    showAILevelMenu, getLevel(Players, ninja).

/* --------------------------------------------------------------- */

/* 40x20 Board */ 
showMainMenu :-
    nl,
    write(' -------------------------------------- \n'),
    write('|                                      |\n'),
    write('|                  Shi                 |\n'),
    write('|                                      |\n'),
    write('|              Joao Mesquita           |\n'),
    write('|                Rui Alves             |\n'),
    write('|                                      |\n'),
    write('|          --------------------        |\n'),
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

showAILevelMenu :-
    nl,
    write(' -------------------------------------- \n'),
    write('|                                      |\n'),
    write('|                  Shi                 |\n'),
    write('|                                      |\n'),
    write('|           -------------------        |\n'),
    write('|                                      |\n'),
    write('|                                      |\n'),
    write('|               1. Easy                |\n'),
    write('|                                      |\n'),
    write('|               2. Hard                |\n'),
    write('|                                      |\n'),
    write('|              0. Go Back              |\n'),
    write('|                                      |\n'),
    write(' -------------------------------------- \n'),
    nl.

showArmyMenu:-
    nl,
    write(' -------------------------------------- \n'),
    write('|                                      |\n'),
    write('|                  Shi                 |\n'),
    write('|                                      |\n'),
    write('|            Choose your army          |\n'),
    write('|                                      |\n'),
    write('|           -------------------        |\n'),
    write('|                                      |\n'),
    write('|              1. Samurais             |\n'),
    write('|                                      |\n'),
    write('|              2. Ninjas               |\n'),
    write('|                                      |\n'),
    write('|              0. Go Back              |\n'),
    write('|                                      |\n'),
    write(' -------------------------------------- \n'),
    nl.