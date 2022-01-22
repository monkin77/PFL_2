# PFL Project 2

This project consists of implementing a board game for 2 players named *Shi* in Prolog.

### Group Identification (Shi_2)
| Name                      | Student nº  | Contribution |
|---------------------------|-------------|--------------|
| João Gil Marinho Mesquita | up201906682 | 50%          |
| Rui Filipe Teixeira Alves | up201905853 | 50%          |

---
## Setup and Execution

---
## Game Description
*Shi* is a 8x8 board game that can be played by 2 players that take the role of **Ninja** and **Samurai**. Initially, there are 8 pieces per side, set up on the players' first row.  
The main goal of this game is to reduce the enemy army to 4 pieces. To do this, all the pieces move like a *Chess Queen*, that is, an unlimited number of cells in all directions and attack the enemy with **jump attacks**. These attacks can only be made by jumping over a single friendly piece along the path of attack. Any number of unoccupied spaces, including none, may exist on that path. Furthermore, the piece being jumped, must always be an ally and never an enemy. For this reason, attacks can only target the first enemy in the path of attack.


---
## Game Logic
### Internal Representation of the Game State

In order to represent the Game State, we decided to have a 2d Array, storing each element of the Board, and a Number representing the current Player, having GameState = Board-Player. Since our game has 2 types of pieces, Samurais and Ninjas, we decided to represent Samurais has `samurai`, Ninjas has `ninja` and empty spaces has `empty`.
Initially, the Board starts with 8 Ninjas and 8 Samurais, where Ninjas are displayed in the first row of Player 2 side and Samurais in the first row of Player 1 side. The other rows start empty.


```prolog
initialBoard([
[ninja,ninja,ninja,ninja,ninja,ninja,ninja,ninja],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[samurai,samurai,samurai,samurai,samurai,samurai,samurai,samurai]
]).

middleBoard([
[ninja,ninja,empty,ninja,ninja,empty,empty,ninja],
[empty,empty,empty,samurai,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,ninja,ninja,empty,empty],
[samurai,empty,samurai,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,samurai,empty,empty,samurai,samurai,samurai]
]).

endBoard([
[ninja,ninja,empty,ninja,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,ninja,ninja,empty,empty],
[samurai,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty,empty],
[empty,empty,ninja,ninja,empty,samurai,samurai,samurai]
]).
```

### Visualization of the Game State

To display to the user the Game State, we decided to show the `Ninjas` elements has `N`, `Samurai` elements has `S` and empty spaces has `-`. Adittionally, we had a line saying which is the current player (Player 1 or Player 2). To do so, we used the following functions: 

- `symbol`, that converts the internal representation to visualization representation of the elements

- `print_text`, that by calling `print_n` writes a text in the screen

- `printBoardHeader`; `printBoardFooter` - displays the board header and footer

- `printBoardRow` - displays a row by iterating through it and writting each element in the screen

- `printBoard` - displays the board by calling the `printBoardRow` function for each row of the board

- `display_game` that calls `printBoardHeader`, `printBoardFooter` and `printBoard` to display the current GameState.

### Turn Execution

- Since our Board is a 2d array, we decided that the plays done by the users would be represented by two numbers representing the row and column of the piece he wants to move. 

- In order to get those values, we use the function `choose_move(Board-Player, human, Move)`, that gets the move and parse it. In our game, the pieces can move like a chess queen, so we use the function `parseMove(StartRow/StartCol, EndRow/EndCol, Direction, StepsX, StepsY)` to get the direction of the move (vertical, horizontal and diagonal) and check if the movement is correct on the game rules. 

- After that, we check if that move is valid in our GameState, by using `isValidMove(Board-Player, CurrMove)` function, that evaluates the board by iterating through the board and checking if it is the move is `Jump Attack` or if doesn't have any ally or enemy piece between the current position and the final position to which we want to move. To do so, we first create a row having all the elements of direction we want to move. Having the row, we then filter it using the `clearPrefix(X, Steps, Direction, Row, Symbol)` function, which will get us the row with the elements we will go throw when we move the piece. Finally, we check if the movement is valid by counting ally pieces we have between the initial position and the final position, using `validateTrajectory(Steps, [Symbol | RemainingRow], Symbol, AllyCount)`.

- After having the desired move and checked if its valid, we use the function `move(GameState, Move, UpdatedGameState)` to apply it, which calls the respective function based on the direction of movement. Consequently, that function will replace the old position by an empty space and the new position with the piece he moved. 

### End Game

The end of the game is reached when a player has only 4 pieces, declaring that the other player won. In order to check that, we used the function `isEndGame(Board)` which will iterate through the Board and count the pieces of each player.

### Valid Plays

### Game's State Evaluation

### Computers's plays

---
## Conclusion

---
## Bibliography