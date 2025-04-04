final int pawn = 1;
final int knight = 2;
final int bishop = 3;
final int rook = 4;
final int queen = 5;
final int king = 6;
final int white = 0;
final int black = 6;
final char[] names = new char[] {'P', 'N', 'B', 'R', 'Q', 'K', 'p', 'n', 'b', 'r', 'q', 'k'};
final char[] cols = new char[] {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
final int[] promotePieces = new int[] {queen, knight, rook, bishop};

int GetType(int piece) {
  if (piece==white+king || piece==black+king) {
    return king;
  }
  return piece%black;
}

boolean IsWhite(int piece) {
  return piece<=black;
}
