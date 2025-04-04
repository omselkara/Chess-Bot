import java.util.Random;

public static class Zobrist {
  static long[][] table;
  static long whiteToMove;
  static long whiteCastleKing;
  static long whiteCastleQueen;
  static long blackCastleKing;
  static long blackCastleQueen;
  static long[] enPassant;

  public static void Setup() {
    table = new long[64][12];
    whiteToMove = Random();
    whiteCastleKing = Random();
    whiteCastleQueen = Random();
    blackCastleKing = Random();
    blackCastleQueen = Random();
    enPassant = new long[65];
    for (int index = 0; index < 64; index++) {
      for (int i = 0; i < 12; i++) {
        table[index][i] = Random();
      }
    }
    for (int index = 0; index < 65; index++) {
      enPassant[index] = Random();
    }
  }
}

static long Random() {
  return new Random().nextLong();
}
