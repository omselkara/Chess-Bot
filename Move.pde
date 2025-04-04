class Move {
  int from, to;
  int atePiece;
  int halfMove;
  int promoteTo;
  int enPassantSquare;
  int enPassant;
  long hashValue;
  boolean doublePush;  
  boolean whiteCastleKing;
  boolean whiteCastleQueen;
  boolean blackCastleKing;
  boolean blackCastleQueen;
  boolean leftCastle;
  boolean rightCastle;
  boolean Null;
  Move(int from, int to, int atePiece, int halfMove, int enPassantSquare, boolean whiteCastleKing, boolean whiteCastleQueen, boolean blackCastleKing, boolean blackCastleQueen,long hashValue) {
    this.from = from;
    this.to = to;
    this.atePiece = atePiece;
    this.halfMove = halfMove;
    this.promoteTo = 0;
    this.enPassantSquare = enPassantSquare;
    this.whiteCastleKing = whiteCastleKing;
    this.whiteCastleQueen = whiteCastleQueen;
    this.blackCastleKing = blackCastleKing;
    this.blackCastleQueen = blackCastleQueen;
    doublePush = false;
    enPassant = -1;
    leftCastle = false;
    rightCastle = false;
    this.hashValue = hashValue;
    Null = false;
  }
  Move(boolean Null){
    this.Null = Null;
  }
  String GetMoveName(){
    if (promoteTo==0){
      return GetName(from)+GetName(to);
    }
    return GetName(from)+GetName(to)+names[GetType(promoteTo)-1];
  }
}
