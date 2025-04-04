import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

/*

GAME BOARD

This is a 2x2 grid with null representing empty space.
A non empty space will have the color to represent the landed pieces

*/

// create game board
List<List<Tetromino?>> gameBoard = List<List<Tetromino?>>.generate(
  colLength,
  (int i) => List<Tetromino?>.generate(rowLength, (int j) => null),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // focus node
  final FocusNode _focusNode = FocusNode();

  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  // current score
  int currentScore = 0;

  // game over status
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    // start game when app starts
    startGame();

    // add focus node
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    const Duration frameRate = Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (Timer timer) {
      setState(() {
        //clear lines
        clearLines();

        // check landing
        checkLanding();

        // check if game is over
        if (gameOver) {
          // stop game loop
          timer.cancel();
          showGameOverDialog();
          return;
        }

        // check if the piece is going to collide with another piece

        // move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  // game over message
  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Game Over'),
            content: Text('Your Score is: $currentScore'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // reset game
                  resetGame();

                  Navigator.pop(context);
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
    );
  }

  // reset game
  void resetGame() {
    // clear the game board
    gameBoard = List<List<Tetromino?>>.generate(
      colLength,
      (int i) => List<Tetromino?>.generate(rowLength, (int j) => null),
    );

    // new game
    gameOver = false;
    currentScore = 0;

    // create a new piece
    createNewPiece();

    // start game again
    startGame();
  }

  // check for collision in future position
  // return true -> there is a collision
  // return false -> there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds (either too low or too far the left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      // check if the current position is already occupied by another piece in the board
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }

    // if no collision are detected, return false
    return false;
  }

  void checkLanding() {
    // if going down is occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        final int row = (currentPiece.position[i] / rowLength).floor();
        final int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed, create the next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object of generate random tetromino types
    final Random rand = Random();

    // create a new piece with a random type
    final Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    /*
    
    Since our game over condition is if there is a piece at the top level, you want to check if the game is over when you create a new piece instead of checking every frame, because new ptieces are allowed to go through the top level but if there is already a piece in the top level when the new piece is created, then it's game over.

    */

    if (isGameOver()) {
      gameOver = true;
    }
  }

  // move left
  void moveLeft() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move right
  void moveRight() {
    // make sure the move is valid before moving there
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // clear lines
  void clearLines() {
    // step 1: loop through each row of the gameboard from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: initialize flag for tracking if a row is full
      bool rowIsFull = true;

      // step 3: check if the row full fall columns in the row are filled with pieces
      for (int col = 0; col < rowLength; col++) {
        // if there's an empty column, set rowIsFull to false and break out of the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: if the row is full, clear the row and shift rows down
      if (rowIsFull) {
        // step 5: move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          // copy the above row to the current row
          gameBoard[r] = List<Tetromino?>.from(gameBoard[r - 1]);
        }

        // step 6: set the top row to empty
        gameBoard[0] = List<Tetromino?>.generate(row, (int index) => null);

        // step 7: increment the score
        currentScore++;
      }
    }
  }

  // GAME OVER
  bool isGameOver() {
    // check if any columns in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    // if the top row is empty, game is not over
    return false;
  }

  // desctop keyboard support
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowRight,
    )) {
      moveRight();
    }

    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowLeft,
    )) {
      moveLeft();
    }

    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowUp,
    )) {
      rotatePiece();
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 330,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Focus(
                  focusNode: _focusNode,
                  onKeyEvent: _handleKeyEvent,
                  child: GridView.builder(
                    itemCount: rowLength * colLength,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowLength,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // get row and col of each index
                      final int row = (index / rowLength).floor();
                      final int col = index % rowLength;

                      // current piece
                      if (currentPiece.position.contains(index)) {
                        return Pixel(color: currentPiece.color);
                      }
                      // landed pieces
                      else if (gameBoard[row][col] != null) {
                        final Tetromino? tetrominoType = gameBoard[row][col];
                        return Pixel(color: tetrominoColors[tetrominoType]);
                      }
                      // blank pixel
                      else {
                        return Pixel(color: Colors.grey[900]);
                      }
                    },
                  ),
                ),
              ),

              // SCORE
              Text(
                'Score: $currentScore',
                style: const TextStyle(color: Colors.white),
              ),

              // GAME CONTROLS
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0, top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // left
                    IconButton(
                      onPressed: moveLeft,
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_back_ios),
                    ),

                    // rotate
                    IconButton(
                      onPressed: rotatePiece,
                      color: Colors.white,
                      icon: const Icon(Icons.rotate_right),
                    ),

                    // right
                    IconButton(
                      onPressed: moveRight,
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
