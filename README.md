# TicTacToe Drawing Application
A simple Tic-Tac-Toe iOS application that allows the users to draw everything by hand - the board, the X's and the O's.

##Playing the Game
 - The game starts with a blank screen, in which the players draw the initial game board. Multi-touch gestures are available as well to draw the initial board.

 - The users draw 4 straight lines to create the board. The game will automatically check the validity of the game board. If it's a correct gameboard, the users can continue to play. If not, the board will be reset and the players will have to re-draw the board.

 - Players take turns drawing X's and O's corresponding to their turns respectively. The game continuously checks the validity of the X's and O's and if each user is drawing their initial chosen X or O. If incorrent or not a valid symbol, it will be erased and the user will have to draw it again.

 - Once a game is over, any user can double tap the screen to clean the current game and start a new one from scratch. This feature is only enabled after a game has finished.

##Detection of User Drawings
###The Game Board
 - A user draws 4 straight lines, in which each line has exactly 1 parallel line and 2 perpendicular lines. If this requirement isn't met, the board will be reset and the users will have to re-draw the board.

###The Players' Moves
 - Each player's move must meet the requirements of their initial chosen symbol of either an X or an O. 
 
 ####O's
 - To meet the X requirements, the centre point of the X is checked in regards to taking all outer points of the X, making it into a rectangle, and comparing against the centre of the rectangle with a proximity function.
 
 ####X's
 - To meet the O requirements, the beginning point of the O is compared to the ending point of the O.
 
 ####Turns
 - The touch strokes are also checked in regards to the validity of if each player is drawing the initial symbol they each have drawn.

There are obviously some opportunities for exploitation which would result the game to accept invalid moves. This needs to be addressed but isn't an immediate concern.

##Next Steps
- Improve the detection of the players' moves

##Acknowledgements
This project was a class assignment for my COMP2601 - Mobile Applications class at Carleton University.
It contains some code written by [Prof. Louis D. Nel](http://people.scs.carleton.ca/~ldnel/) and the TA, Sean Benjamin.
Their works are cited within the project.
