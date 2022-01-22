mainMenu :-
    showMainMenu,
    getOption.

getOption :-
    write('Insert an option -> '),
    read_until_between(0, 2, Option),
    handleOption(Option).

handleOption(1) :-
    !, play_game(human).

handleOption(2) :-
    !, play_game(computer-easy).

handleOption(3) :-
    !, play_game(computer2-easy).

handleOption(0) :-
    write('Leaving...\n').

handleOption(_) :-
    write('That is not a valid option!\n\n'),
    getOption.

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