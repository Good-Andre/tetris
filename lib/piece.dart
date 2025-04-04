import 'package:flutter/material.dart';
import 'package:tetris/board.dart';
import 'package:tetris/values.dart';

class Piece {
  // type of tetris piece
  Tetromino type;

  Piece({required this.type});

  // the piece is just a list of integers
  List<int> position = <int>[];

  // color of tetris piece
  Color get color {
    return tetrominoColors[type] ?? const Color(0xFFFFFFFF);
  }

  // generate the integers
  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = <int>[-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = <int>[-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = <int>[-4, -5, -6, -7];
        break;
      case Tetromino.O:
        position = <int>[-15, -16, -5, -6];
        break;
      case Tetromino.S:
        position = <int>[-15, -14, -6, -5];
        break;
      case Tetromino.Z:
        position = <int>[-17, -16, -6, -5];
        break;
      case Tetromino.T:
        position = <int>[-26, -16, -6, -15];
        break;
    }
  }

  // move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
    }
  }

  // rotate piece
  int rotationState = 1;

  void rotatePiece() {
    List<int> newPosition = <int>[];

    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            /*
          
          o
          o
          o o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
          o o o
          o

          */

            // get the new position
            newPosition = <int>[
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
          o o 
            o
            o

          */

            // get the new position
            newPosition = <int>[
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

              o
          o o o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            /*
          
            o
            o
          o o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
          o
          o o o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
          o o 
          o
          o

          */

            // get the new position
            newPosition = <int>[
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

          o o o
              o

          */

            // get the new position
            newPosition = <int>[
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            /*
          
          o o o o

          */

            // get the new position
            newPosition = <int>[
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
          o
          o
          o
          o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
          o o o o
          

          */

            // get the new position
            newPosition = <int>[
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

          o
          o
          o
          o

          */

            // get the new position
            newPosition = <int>[
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetromino.O:
        /*
        
        o o
        o o

        */
        break;

      case Tetromino.S:
        switch (rotationState) {
          case 0:
            /*
          
            o o
          o o

          */

            // get the new position
            newPosition = <int>[
              position[1] + 1,
              position[1] + 2,
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
          o
          o o
            o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength - 1,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
            o o
          o o

          */

            // get the new position
            newPosition = <int>[
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*
          
          o
          o o
            o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength - 2,
              position[1] - 2,
              position[1] - 1,
              position[1] + rowLength - 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            /*
          
          o o
            o o

          */

            // get the new position
            newPosition = <int>[
              position[1] + rowLength + 1,
              position[1] - 1,
              position[1] + rowLength,
              position[1],
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
            o
          o o
          o

          */

            // get the new position
            newPosition = <int>[
              position[1],
              position[1] + 1,
              position[1] - rowLength + 1,
              position[1] + rowLength,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
          o o
            o o

          */

            // get the new position
            newPosition = <int>[
              position[1] + rowLength,
              position[1] - 2,
              position[1] + rowLength - 1,
              position[1] - 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

            o
          o o
          o

          */

            // get the new position
            newPosition = <int>[
              position[1] + 1,
              position[1] + 2,
              position[1] - rowLength + 2,
              position[1] + rowLength + 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*
          
          o
          o o
          o 

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength + 1,
              position[1] + 1,
              position[1] + 2,
              position[1] + rowLength + 1,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 1:
            /*
          
          o o o
            o
          
          */

            // get the new position
            newPosition = <int>[
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 2:
            /*
          
            o
          o o
            o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            /*

            o
          o o o

          */

            // get the new position
            newPosition = <int>[
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            // check this new position is valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              // update position
              position = newPosition;
              // update rotation state
              rotationState = 0;
            }
            break;
        }
        break;
    }
  }

  // check if valid position
  bool positionIsValid(int position) {
    // get the row and col of position
    final int row = (position / rowLength).floor();
    final int col = position % rowLength;

    // if the position is taken return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }
    // otherwise position is valid return true
    else {
      return true;
    }
  }

  // check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (final int pos in piecePosition) {
      // return false if any position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      // get the col of position
      final int col = pos % rowLength;

      // check if the first or last col is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // if there is a piece in the first col and the last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}
