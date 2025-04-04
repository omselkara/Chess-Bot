final String standartFen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
//int[] knightFaces = new int[] {-17,-15,+15,+17,-10,-6,+6,+10};
//int[][] knightLimits = new int[][] {{1,7,2,7},{0,6,2,7},{1,7,0,5},{0,6,0,5},{2,7,1,7},{0,5,1,7},{2,7,0,6},{0,5,0,6}};

class Game {
  int[] board;
  boolean whitesTurn = true;
  boolean whiteCastleKing = false;
  boolean whiteCastleQueen = false;
  boolean blackCastleKing = false;
  boolean blackCastleQueen = false;
  int whiteKingIndex, blackKingIndex;
  int enPassant = -1;
  int halfMove = 0;
  int fullMove = 1;
  int whiteCount = 0;
  int blackCount = 0;
  long hashValue;
  RepetetionTable repetetionTable;

  Game(boolean load) {
    board = new int[64];
    whiteKingIndex = -1;
    blackKingIndex = -1;
    whiteCount = 0;
    blackCount = 0;
    if (load) {
      LoadFen(standartFen);
    }
  }

  Game() {
    ;
    board = new int[64];
    whiteKingIndex = -1;
    blackKingIndex = -1;
    whiteCount = 0;
    blackCount = 0;
    LoadFen(standartFen);
  }

  Game(String fen) {
    board = new int[64];
    whiteKingIndex = -1;
    blackKingIndex = -1;
    whiteCount = 0;
    blackCount = 0;
    LoadFen(fen);
  }

  boolean IsLegal(Move move) {
    MakeMove(move);
    boolean check = whitesTurn ? IsBlackInCheck():IsWhiteInCheck();
    UndoMove(move);
    return !check;
  }

  MoveList MoveGenerator(boolean legalMoves) {
    MoveList moves = new MoveList();
    if (whitesTurn) {
      int num = 0;
      for (int index=63; index>=0; index--) {
        if (board[index]!=0 && IsWhite(board[index])) {
          num++;
          GenerateMovesAt(index, legalMoves, moves);
          if (num==whiteCount) {
            break;
          }
        }
      }
    } else {
      int num = 0;
      for (int index=0; index<64; index++) {
        if (board[index]!=0 && !IsWhite(board[index])) {
          num++;
          GenerateMovesAt(index, legalMoves, moves);
          if (num==blackCount) {
            break;
          }
        }
      }
    }
    return moves;
  }

  MoveList GenerateMovesAt(int index, boolean legalMoves) {
    MoveList moves = new MoveList();
    int type = GetType(board[index]);
    boolean isWhite = IsWhite(board[index]);
    if (type==pawn) {
      if (isWhite) {
        if (board[index-8]==0) {
          if (index<16) {
            boolean checked = false;
            for (int piece : promotePieces) {
              Move move = new Move(index, index-8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.promoteTo = white+piece;
              if (!checked) {
                checked = true;
                if (legalMoves && !IsLegal(move)) {
                  break;
                }
              }
              moves.add(move);
            }
          } else {
            Move move = new Move(index, index-8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
            if (index>=48 && index<=55 && board[index-16]==0) {
              move = new Move(index, index-16, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.doublePush = true;
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        int x = GetX(index);
        if (x<7) {
          int to = index-7;
          if (board[to]!=0 && !IsWhite(board[to])) {
            if (to<8) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = white+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (x>0) {
          int to = index-9;
          if (board[to]!=0 && !IsWhite(board[to])) {
            if (to<8) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = white+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (enPassant!=-1 && index>=24 && index<=31) {
          if (enPassant==index+1) {
            Move move = new Move(index, index-7, black+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index+1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          } else if (enPassant==index-1) {
            Move move = new Move(index, index-9, black+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index-1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
        }
      } else {
        if (board[index+8]==0) {
          if (index>=48) {
            boolean checked = false;
            for (int piece : promotePieces) {
              Move move = new Move(index, index+8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.promoteTo = black+piece;
              if (!checked) {
                checked = true;
                if (legalMoves && !IsLegal(move)) {
                  break;
                }
              }
              moves.add(move);
            }
          } else {
            Move move = new Move(index, index+8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
            if (index>=8 && index<=15 && board[index+16]==0) {
              move = new Move(index, index+16, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.doublePush = true;
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        int x = GetX(index);
        if (x<7) {
          int to = index+9;
          if (board[to]!=0 && IsWhite(board[to])) {
            if (to>=56) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = black+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (x>0) {
          int to = index+7;
          if (board[to]!=0 && IsWhite(board[to])) {
            if (to>=56) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = black+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (enPassant!=-1 && index>=32 && index<=39) {
          if (enPassant==index+1) {
            Move move = new Move(index, index+9, white+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index+1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          } else if (enPassant==index-1) {
            Move move = new Move(index, index+7, white+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index-1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
        }
      }
    } else if (type==knight) {
      for (int to : pieceMoves[0][index]) {
        if (board[to]==0 || IsWhite(board[to])!=isWhite) {
          Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
          if (!legalMoves || IsLegal(move)) {
            moves.add(move);
          }
        }
      }
    } else if (type==bishop || type==rook || type==queen) {
      int startindex = type==rook ? 4:0;
      int endindex = type==bishop ? 4:8;
      for (int i=startindex; i<endindex; i++) {
        int pos = index;
        int upgrade = faces[i];
        int target = pieceMoves[3][index][i];
        if (pos==target) {
          continue;
        }
        for (int step=0; step<8; step++) {
          pos += upgrade;
          if (board[pos]!=0) {
            if (IsWhite(board[pos])!=isWhite) {
              Move move = new Move(index, pos, board[pos], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
            break;
          } else {
            Move move = new Move(index, pos, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
          if (pos==target) {
            break;
          }
        }
      }
    } else {
      for (int to : pieceMoves[4][index]) {
        if (board[to]!=0) {
          if (IsWhite(board[to])!=isWhite) {
            Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
        } else {
          Move move = new Move(index, to, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
          if (!legalMoves || IsLegal(move)) {
            moves.add(move);
          }
        }
      }
      if (isWhite) {
        if (index==60) {
          if (whiteCastleKing) {
            if (board[61]==0 && board[62]==0 && !CanCapture(60, true) && !CanCapture(61, true) && !CanCapture(62, true)) {
              Move move = new Move(index, 62, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.rightCastle = true;
              moves.add(move);
            }
          }
          if (whiteCastleQueen) {
            if (board[59]==0 && board[58]==0 && board[57]==0 && !CanCapture(60, true) && !CanCapture(59, true) && !CanCapture(58, true)) {
              Move move = new Move(index, 58, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.leftCastle = true;
              moves.add(move);
            }
          }
        }
      } else {
        if (index==4) {
          if (blackCastleKing) {
            if (board[5]==0 && board[6]==0 && !CanCapture(4, false) && !CanCapture(5, false) && !CanCapture(6, false)) {
              Move move = new Move(index, 6, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.rightCastle = true;
              moves.add(move);
            }
          }
          if (blackCastleQueen) {
            if (board[3]==0 && board[2]==0 && board[1]==0 && !CanCapture(4, false) && !CanCapture(3, false) && !CanCapture(2, false)) {
              Move move = new Move(index, 2, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.leftCastle = true;
              moves.add(move);
            }
          }
        }
      }
    }
    return moves;
  }
  MoveList GenerateMovesAt(int index, boolean legalMoves, MoveList moves) {
    int type = GetType(board[index]);
    boolean isWhite = IsWhite(board[index]);
    if (type==pawn) {
      if (isWhite) {
        if (board[index-8]==0) {
          if (index<16) {
            boolean checked = false;
            for (int piece : promotePieces) {
              Move move = new Move(index, index-8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.promoteTo = white+piece;
              if (!checked) {
                checked = true;
                if (legalMoves && !IsLegal(move)) {
                  break;
                }
              }
              moves.add(move);
            }
          } else {
            Move move = new Move(index, index-8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
            if (index>=48 && index<=55 && board[index-16]==0) {
              move = new Move(index, index-16, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.doublePush = true;
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        int x = GetX(index);
        if (x<7) {
          int to = index-7;
          if (board[to]!=0 && !IsWhite(board[to])) {
            if (to<8) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = white+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (x>0) {
          int to = index-9;
          if (board[to]!=0 && !IsWhite(board[to])) {
            if (to<8) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = white+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (enPassant!=-1 && index>=24 && index<=31) {
          if (enPassant==index+1) {
            Move move = new Move(index, index-7, black+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index+1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          } else if (enPassant==index-1) {
            Move move = new Move(index, index-9, black+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index-1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
        }
      } else {
        if (board[index+8]==0) {
          if (index>=48) {
            boolean checked = false;
            for (int piece : promotePieces) {
              Move move = new Move(index, index+8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.promoteTo = black+piece;
              if (!checked) {
                checked = true;
                if (legalMoves && !IsLegal(move)) {
                  break;
                }
              }
              moves.add(move);
            }
          } else {
            Move move = new Move(index, index+8, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
            if (index>=8 && index<=15 && board[index+16]==0) {
              move = new Move(index, index+16, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.doublePush = true;
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        int x = GetX(index);
        if (x<7) {
          int to = index+9;
          if (board[to]!=0 && IsWhite(board[to])) {
            if (to>=56) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = black+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (x>0) {
          int to = index+7;
          if (board[to]!=0 && IsWhite(board[to])) {
            if (to>=56) {
              boolean checked = false;
              for (int piece : promotePieces) {
                Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
                move.promoteTo = black+piece;
                if (!checked) {
                  checked = true;
                  if (legalMoves && !IsLegal(move)) {
                    break;
                  }
                }
                moves.add(move);
              }
            } else {
              Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
          }
        }
        if (enPassant!=-1 && index>=32 && index<=39) {
          if (enPassant==index+1) {
            Move move = new Move(index, index+9, white+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index+1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          } else if (enPassant==index-1) {
            Move move = new Move(index, index+7, white+pawn, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            move.enPassant = index-1;
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
        }
      }
    } else if (type==knight) {
      for (int to : pieceMoves[0][index]) {
        if (board[to]==0 || IsWhite(board[to])!=isWhite) {
          Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
          if (!legalMoves || IsLegal(move)) {
            moves.add(move);
          }
        }
      }
    } else if (type==bishop || type==rook || type==queen) {
      int startindex = type==rook ? 4:0;
      int endindex = type==bishop ? 4:8;
      for (int i=startindex; i<endindex; i++) {
        int pos = index;
        int upgrade = faces[i];
        int target = pieceMoves[3][index][i];
        if (pos==target) {
          continue;
        }
        for (int step=0; step<8; step++) {
          pos += upgrade;
          if (board[pos]!=0) {
            if (IsWhite(board[pos])!=isWhite) {
              Move move = new Move(index, pos, board[pos], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              if (!legalMoves || IsLegal(move)) {
                moves.add(move);
              }
            }
            break;
          } else {
            Move move = new Move(index, pos, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
          if (pos==target) {
            break;
          }
        }
      }
    } else {
      for (int to : pieceMoves[4][index]) {
        if (board[to]!=0) {
          if (IsWhite(board[to])!=isWhite) {
            Move move = new Move(index, to, board[to], halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
            if (!legalMoves || IsLegal(move)) {
              moves.add(move);
            }
          }
        } else {
          Move move = new Move(index, to, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
          if (!legalMoves || IsLegal(move)) {
            moves.add(move);
          }
        }
      }
      if (isWhite) {
        if (index==60) {
          if (whiteCastleKing) {
            if (board[61]==0 && board[62]==0 && !CanCapture(60, true) && !CanCapture(61, true) && !CanCapture(62, true)) {
              Move move = new Move(index, 62, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.rightCastle = true;
              moves.add(move);
            }
          }
          if (whiteCastleQueen) {
            if (board[59]==0 && board[58]==0 && board[57]==0 && !CanCapture(60, true) && !CanCapture(59, true) && !CanCapture(58, true)) {
              Move move = new Move(index, 58, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.leftCastle = true;
              moves.add(move);
            }
          }
        }
      } else {
        if (index==4) {
          if (blackCastleKing) {
            if (board[5]==0 && board[6]==0 && !CanCapture(4, false) && !CanCapture(5, false) && !CanCapture(6, false)) {
              Move move = new Move(index, 6, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.rightCastle = true;
              moves.add(move);
            }
          }
          if (blackCastleQueen) {
            if (board[3]==0 && board[2]==0 && board[1]==0 && !CanCapture(4, false) && !CanCapture(3, false) && !CanCapture(2, false)) {
              Move move = new Move(index, 2, 0, halfMove, enPassant, whiteCastleKing, whiteCastleQueen, blackCastleKing, blackCastleQueen, hashValue);
              move.leftCastle = true;
              moves.add(move);
            }
          }
        }
      }
    }
    return moves;
  }


  void MakeMove(Move move) {
    hashValue ^= Zobrist.whiteToMove;
    halfMove++;
    if (move.atePiece!=0) {
      halfMove = 0;
      if (move.enPassant!=-1) {
        hashValue ^= Zobrist.table[move.enPassant][board[move.enPassant]-1];
        board[move.enPassant] = 0;
      } else {
        hashValue ^= Zobrist.table[move.to][board[move.to]-1];
      }
      if (whitesTurn) {
        blackCount--;
      } else {
        whiteCount--;
      }
      if (move.atePiece==white+rook && whiteCastleKing) {
        if (move.to==63) {
          whiteCastleKing = false;
          hashValue ^= Zobrist.whiteCastleKing;
        } else if (move.to==56 && whiteCastleQueen) {
          whiteCastleQueen = false;
          hashValue ^= Zobrist.whiteCastleQueen;
        }
      } else if (move.atePiece==black+rook) {
        if (move.to==7 && blackCastleKing) {
          blackCastleKing = false;
          hashValue ^= Zobrist.blackCastleKing;
        } else if (move.to==0 && blackCastleQueen) {
          blackCastleQueen = false;
          hashValue ^= Zobrist.blackCastleQueen;
        }
      }
    }
    hashValue ^= Zobrist.table[move.from][board[move.from]-1];
    if (move.promoteTo==0) {
      board[move.to] = board[move.from];
    } else {
      board[move.to] = move.promoteTo;
    }
    hashValue ^= Zobrist.table[move.to][board[move.to]-1];
    board[move.from] = 0;
    if (!whitesTurn) {
      fullMove++;
    }
    if (move.from==whiteKingIndex) {
      whiteKingIndex = move.to;
      if (whiteCastleKing) {
        whiteCastleKing = false;
        hashValue ^= Zobrist.whiteCastleKing;
      }
      if (whiteCastleQueen) {
        whiteCastleQueen = false;
        hashValue ^= Zobrist.whiteCastleQueen;
      }
      if (move.rightCastle) {
        hashValue ^= Zobrist.table[63][white+rook-1];
        hashValue ^= Zobrist.table[61][white+rook-1];
        board[61] = board[63];
        board[63] = 0;
      } else if (move.leftCastle) {
        hashValue ^= Zobrist.table[56][white+rook-1];
        hashValue ^= Zobrist.table[59][white+rook-1];
        board[59] = board[56];
        board[56] = 0;
      }
    } else if (move.from==blackKingIndex) {
      blackKingIndex = move.to;
      if (blackCastleKing) {
        hashValue ^= Zobrist.blackCastleKing;
        blackCastleKing = false;
      }
      if (blackCastleQueen) {
        hashValue ^= Zobrist.blackCastleQueen;
        blackCastleQueen = false;
      }
      if (move.rightCastle) {
        hashValue ^= Zobrist.table[7][black+rook-1];
        hashValue ^= Zobrist.table[5][black+rook-1];
        board[5] = board[7];
        board[7] = 0;
      } else if (move.leftCastle) {
        hashValue ^= Zobrist.table[0][black+rook-1];
        hashValue ^= Zobrist.table[3][black+rook-1];
        board[3] = board[0];
        board[0] = 0;
      }
    } else {
      int type = GetType(board[move.to]);
      if (whitesTurn) {
        if (type==rook) {
          if (move.from==63) {
            if (whiteCastleKing) {
              whiteCastleKing = false;
              hashValue ^= Zobrist.whiteCastleKing;
            }
          } else if (move.from==56) {
            if (whiteCastleQueen) {
              whiteCastleQueen = false;
              hashValue ^= Zobrist.whiteCastleQueen;
            }
          }
        }
      } else {
        if (type==rook) {
          if (move.from==7) {
            if (blackCastleKing) {
              blackCastleKing = false;
              hashValue ^= Zobrist.blackCastleKing;
            }
          } else if (move.from==0) {
            if (blackCastleQueen) {
              blackCastleQueen = false;
              hashValue ^= Zobrist.blackCastleQueen;
            }
          }
        }
      }
    }
    if (GetType(board[move.to])==pawn) {
      halfMove = 0;
    }
    whitesTurn = !whitesTurn;
    if (move.doublePush) {
      hashValue ^= Zobrist.enPassant[enPassant+1];
      enPassant = move.to;
      hashValue ^= Zobrist.enPassant[enPassant+1];
    } else if (enPassant!=-1) {
      hashValue ^= Zobrist.enPassant[enPassant+1];
      enPassant = -1;
      hashValue ^= Zobrist.enPassant[0];
    }
    AddToTable();
    /*println(whitesTurn);
     println(whiteCastleKing);
     println(whiteCastleQueen);
     println(blackCastleKing);
     println(blackCastleQueen);
     println(enPassant);
     println(halfMove);
     println(fullMove);*/
  }
  void UndoMove(Move move) {
    hashValue = move.hashValue;
    enPassant = move.enPassantSquare;
    board[move.from] = board[move.to];
    if (move.atePiece!=0) {
      if (whitesTurn) {
        whiteCount++;
      } else {
        blackCount++;
      }
    }
    if (move.enPassant==-1) {
      if (move.promoteTo!=0) {
        board[move.from] = (whitesTurn ? black : white)+pawn;
      }
      board[move.to] = move.atePiece;
    } else {
      board[move.to] = 0;
      board[move.enPassant] = move.atePiece;
    }
    if (whitesTurn) {
      fullMove--;
    }
    if (move.to==whiteKingIndex) {
      whiteKingIndex = move.from;
      if (move.rightCastle) {
        board[63] = board[61];
        board[61] = 0;
      } else if (move.leftCastle) {
        board[56] = board[59];
        board[59] = 0;
      }
    } else if (move.to==blackKingIndex) {
      blackKingIndex = move.from;
      if (move.rightCastle) {
        board[7] = board[5];
        board[5] = 0;
      } else if (move.leftCastle) {
        board[0] = board[3];
        board[3] = 0;
      }
    }
    whitesTurn = !whitesTurn;
    halfMove = move.halfMove;
    whiteCastleKing = move.whiteCastleKing;
    whiteCastleQueen = move.whiteCastleQueen;
    blackCastleKing = move.blackCastleKing;
    blackCastleQueen = move.blackCastleQueen;
    repetetionTable.pop();
    /*println(whitesTurn);
     println(whiteCastleKing);
     println(whiteCastleQueen);
     println(blackCastleKing);
     println(blackCastleQueen);
     println(enPassant);
     println(halfMove);
     println(fullMove);*/
  }

  boolean CanCapture(int captureIndex, boolean isWhite) {
    if (isWhite) {
      for (int index : pieceMoves[0][captureIndex]) {
        if (board[index]==black+knight) {
          return true;
        }
      }
      for (int i=0; i<4; i++) {
        int pos = captureIndex;
        while (pos!=pieceMoves[1][captureIndex][i]) {
          pos += faces[i];
          if (board[pos]!=0) {
            if (!IsWhite(board[pos])) {
              int type = GetType(board[pos]);
              if (type==bishop || type==queen || (((type==pawn && i>=0 && i<2)||type==king) && pos==captureIndex+faces[i])) {
                return true;
              }
            }
            break;
          }
        }
      }
      for (int i=4; i<8; i++) {
        int pos = captureIndex;
        while (pos!=pieceMoves[2][captureIndex][i-4]) {
          pos += faces[i];
          if (board[pos]!=0) {
            if (!IsWhite(board[pos])) {
              int type = GetType(board[pos]);
              if (type==rook || type==queen || (type==king && pos==captureIndex+faces[i])) {
                return true;
              }
            }
            break;
          }
        }
      }
    } else {
      for (int index : pieceMoves[0][captureIndex]) {
        if (board[index]==white+knight) {
          return true;
        }
      }
      for (int i=0; i<4; i++) {
        int pos = captureIndex;
        while (pos!=pieceMoves[1][captureIndex][i]) {
          pos += faces[i];
          if (board[pos]!=0) {
            if (IsWhite(board[pos])) {
              int type = GetType(board[pos]);
              if (type==bishop || type==queen || (((type==pawn && i>=2 && i<4)||type==king) && pos==captureIndex+faces[i])) {
                return true;
              }
            }
            break;
          }
        }
      }
      for (int i=4; i<8; i++) {
        int pos = captureIndex;
        while (pos!=pieceMoves[2][captureIndex][i-4]) {
          pos += faces[i];
          if (board[pos]!=0) {
            if (IsWhite(board[pos])) {
              int type = GetType(board[pos]);
              if (type==rook || type==queen || (type==king && pos==captureIndex+faces[i])) {
                return true;
              }
            }
            break;
          }
        }
      }
    }
    return false;
  }

  boolean IsWhiteInCheck() {
    return CanCapture(whiteKingIndex, true);
  }

  boolean IsBlackInCheck() {
    return CanCapture(blackKingIndex, false);
  }

  void LoadFen(String fen) {
    int charindex = 0;
    int boardindex = 0;
    board = new int[64];
    whiteKingIndex = -1;
    blackKingIndex = -1;
    whiteCount = 0;
    blackCount = 0;
    while (true) {
      char chr = fen.charAt(charindex);
      if (chr==' ') {
        break;
      }
      if (chr=='P') {
        board[boardindex] = white+pawn;
        boardindex++;
        whiteCount++;
      } else if (chr=='N') {
        board[boardindex] = white+knight;
        boardindex++;
        whiteCount++;
      } else if (chr=='B') {
        board[boardindex] = white+bishop;
        boardindex++;
        whiteCount++;
      } else if (chr=='R') {
        board[boardindex] = white+rook;
        boardindex++;
        whiteCount++;
      } else if (chr=='Q') {
        board[boardindex] = white+queen;
        boardindex++;
        whiteCount++;
      } else if (chr=='K') {
        board[boardindex] = white+king;
        whiteKingIndex = boardindex;
        boardindex++;
        whiteCount++;
      } else if (chr=='p') {
        board[boardindex] = black+pawn;
        boardindex++;
        blackCount++;
      } else if (chr=='n') {
        board[boardindex] = black+knight;
        boardindex++;
        blackCount++;
      } else if (chr=='b') {
        board[boardindex] = black+bishop;
        boardindex++;
        blackCount++;
      } else if (chr=='r') {
        board[boardindex] = black+rook;
        boardindex++;
        blackCount++;
      } else if (chr=='q') {
        board[boardindex] = black+queen;
        boardindex++;
        blackCount++;
      } else if (chr=='k') {
        board[boardindex] = black+king;
        blackKingIndex = boardindex;
        boardindex++;
        blackCount++;
      } else if (chr=='1') {
        boardindex += 1;
      } else if (chr=='2') {
        boardindex += 2;
      } else if (chr=='3') {
        boardindex += 3;
      } else if (chr=='4') {
        boardindex += 4;
      } else if (chr=='5') {
        boardindex += 5;
      } else if (chr=='6') {
        boardindex += 6;
      } else if (chr=='7') {
        boardindex += 7;
      } else if (chr=='8') {
        boardindex += 8;
      } else if (chr=='/') {
      } else {
        println("Hata Fen Taş Yerleştirme");
      }
      charindex++;
    }
    if (whiteKingIndex==-1) {
      println("Hata Fen Beyaz Şah Pozisyonu");
    }
    if (blackKingIndex==-1) {
      println("Hata Fen Siyah Şah Pozisyonu");
    }
    charindex++;
    if (fen.charAt(charindex)=='w') {
      whitesTurn = true;
    } else if (fen.charAt(charindex)=='b') {
      whitesTurn = false;
    } else {
      println("Hata Fen Sıra Bulma");
    }
    charindex += 2;
    if (fen.charAt(charindex)!='-') {
      while (fen.charAt(charindex)!=' ') {
        if (fen.charAt(charindex)=='K') {
          whiteCastleKing = true;
        } else if (fen.charAt(charindex)=='Q') {
          whiteCastleQueen = true;
        } else if (fen.charAt(charindex)=='k') {
          blackCastleKing = true;
        } else if (fen.charAt(charindex)=='q') {
          blackCastleQueen = true;
        }
        charindex++;
      }
      charindex--;
    }
    charindex += 2;
    if (fen.charAt(charindex)!='-') {
      int index = -1;
      for (int i=0; i<8; i++) {
        if (fen.charAt(charindex)==cols[i]) {
          index = i;
          break;
        }
      }
      if (index==-1) {
        println("Hata Fen En Passant");
      }
      charindex++;
      int rank = (int)(fen.charAt(charindex));
      if (rank<0 || rank>7) {
        println("Hata Fen En Passant");
      }
      index += 8*rank;
      enPassant = index;
    }
    charindex += 2;
    String str = "";
    while (fen.charAt(charindex)!=' ') {
      str += fen.charAt(charindex);
      charindex++;
    }
    charindex++;
    halfMove = Integer.parseInt(str);
    str = "";
    while (charindex<fen.length()) {
      str += fen.charAt(charindex);
      charindex++;
    }
    fullMove = Integer.parseInt(str);
    hashValue = GenerateHash();
    repetetionTable = new RepetetionTable();
    AddToTable();
    /*PrintBoard();
     println(whitesTurn);
     println(whiteCastleKing);
     println(whiteCastleQueen);
     println(blackCastleKing);
     println(blackCastleQueen);
     println(enPassant);
     println(halfMove);
     println(fullMove);*/
  }
  void PrintBoard() {
    println("---------------------------------");
    for (int y=0; y<8; y++) {
      String str = "| ";
      for (int x=0; x<8; x++) {
        str += (board[y*8+x]!=0) ? names[(int)board[y*8+x]-1]:' ';
        str += " | ";
      }
      println(str);
      println("---------------------------------");
    }
  }
  Game Clone() {
    Game clone = new Game(false);
    clone.board = new int[64];
    for (int index=0; index<64; index++) {
      clone.board[index] = board[index];
    }
    clone.whitesTurn = whitesTurn;
    clone.whiteCastleKing = whiteCastleKing;
    clone.whiteCastleQueen = whiteCastleQueen;
    clone.blackCastleKing = blackCastleKing;
    clone.blackCastleQueen = blackCastleQueen;
    clone.whiteKingIndex = whiteKingIndex;
    clone.blackKingIndex = blackKingIndex;
    clone.enPassant = enPassant;
    clone.halfMove = halfMove;
    clone.fullMove = fullMove;
    clone.whiteCount = whiteCount;
    clone.blackCount = blackCount;
    clone.hashValue = hashValue;
    clone.repetetionTable = new RepetetionTable();
    clone.repetetionTable.list = (ArrayList<Long>) repetetionTable.list.clone();
    return clone;
  }

  boolean IsMate() {
    return (MoveGenerator(true).size()==0 && IsCheck());
  }

  boolean IsCheck() {
    return ((!whitesTurn && IsBlackInCheck()) || (whitesTurn && IsWhiteInCheck()));
  }

  float Evaluate() {
    float score = 0;
    int num = 0;
    int target = whiteCount+blackCount;
    float endGameScore = 8f/target;
    if (target>=16){
      endGameScore = 0;
    }
    for (int index=0; index<64; index++) {
      if (board[index]!=0) {
        boolean isWhite = IsWhite(board[index]);
        int type = GetType(board[index]);
        if (isWhite) {
          score += scores[type-1];
          if (type==pawn) {
            score += pawnRelativeScores[index];
          } else if (type==knight) {
            score += knightRelativeScores[index];
          } else if (type==bishop) {
            score += bishopRelativeScores[index];
          } else if (type==rook) {
            score += rookRelativeScores[index];
          } else if (type==queen) {
            score += queenRelativeScores[index];
          } else {            
            score += kingRelativeScores[index]+(kingRelativeEndScores[index]-kingRelativeScores[index])*endGameScore;
          }
        } else {
          score -= scores[type-1];
          if (type==pawn) {
            score -= pawnRelativeScores[63-index];
          } else if (type==knight) {
            score -= knightRelativeScores[63-index];
          } else if (type==bishop) {
            score -= bishopRelativeScores[63-index];
          } else if (type==rook) {
            score -= rookRelativeScores[63-index];
          } else if (type==queen) {
            score -= queenRelativeScores[63-index];
          } else {
            score -= kingRelativeScores[63-index]+(kingRelativeEndScores[63-index]-kingRelativeScores[63-index])*endGameScore;
          }
        }
        num++;
        if (num==target) {
          break;
        }
      }
    }
    int kingScore = 0;
    int opponentIndex = whitesTurn ? blackKingIndex:whiteKingIndex;
    int otherIndex = whitesTurn ? whiteKingIndex:blackKingIndex;
    int x = GetX(opponentIndex);
    int y = GetY(opponentIndex);
    int distX = max(3-x,x-4);
    int distY = max(3-y,y-4);
    int dist = distX+distY;
    kingScore += dist;
    int otherX = GetX(otherIndex);
    int otherY = GetY(otherIndex);
    int distKings = abs(x-otherX)+abs(y-otherY);
    kingScore += 14-distKings;
    score += kingScore*endGameScore/10f;
    score *= whitesTurn ? 1:-1;
    return score;
  }

  boolean IsDraw() {
    return (halfMove>=50) || (whiteCount==1 && blackCount==1) || CheckRepetetion();
  }
  
  
  void AddToTable(){
    repetetionTable.add(hashValue);
  }
  
  boolean CheckRepetetion(){
    boolean draw = repetetionTable.IsDraw(hashValue);
    return draw;
  }

  long GenerateHash() {
    long value = 0;
    for (int index = 0; index < 64; index++) {
      if (board[index] != 0) {
        value ^= Zobrist.table[index][board[index] - 1];
      }
    }
    if (whitesTurn) {
      value ^= Zobrist.whiteToMove;
    }
    if (whiteCastleKing) {
      value ^= Zobrist.whiteCastleKing;
    }
    if (whiteCastleQueen) {
      value ^= Zobrist.whiteCastleQueen;
    }
    if (blackCastleKing) {
      value ^= Zobrist.blackCastleKing;
    }
    if (blackCastleQueen) {
      value ^= Zobrist.blackCastleQueen;
    }
    value ^= Zobrist.enPassant[enPassant + 1];
    return value;
  }
}

char[] chrs = new char[] {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
char[] nums = new char[] {'1', '2', '3', '4', '5', '6', '7', '8'};

String GetName(int index) {
  int y = 7-GetY(index);
  int x = GetX(index);
  return str(chrs[x])+str(nums[y]);
}
