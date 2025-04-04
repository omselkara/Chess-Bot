int[] faces = new int[] {-9, -7, +7, +9, -8, -1, +1, +8};
int[][] otherFaces = new int[][] {{-1, -1}, {+1, -1}, {-1, +1}, {+1, +1}, {0, -1}, {-1, 0}, {+1, 0}, {0, +1}};
int[][] whitePawnMoves = new int[64][];
int[][] blackPawnMoves = new int[64][];
int[][][] pieceMoves = new int[5][64][];
int[][] rookLimits = new int[][] {{-10, 0}, {0, -10}, {7, -10}, {-10, 7}};

void PrepareMoves() {
  for (int y=0; y<8; y++) {
    for (int x=0; x<8; x++) {
      ArrayList<Integer> calculated = new ArrayList<Integer>();
      if (x>=1 && y>=2) {
        calculated.add(GetIndex(x-1, y-2));
      }
      if (x<=6 && y>=2) {
        calculated.add(GetIndex(x+1, y-2));
      }
      if (x>=1 && y<=5) {
        calculated.add(GetIndex(x-1, y+2));
      }
      if (x<=6 && y<=5) {
        calculated.add(GetIndex(x+1, y+2));
      }
      if (x>=2 && y>=1) {
        calculated.add(GetIndex(x-2, y-1));
      }
      if (x>=2 && y<=6) {
        calculated.add(GetIndex(x-2, y+1));
      }
      if (x<=5 && y>=1) {
        calculated.add(GetIndex(x+2, y-1));
      }
      if (x<=5 && y<=6) {
        calculated.add(GetIndex(x+2, y+1));
      }
      pieceMoves[0][GetIndex(x, y)] = new int[calculated.size()];
      for (int i=0; i<calculated.size(); i++) {
        pieceMoves[0][GetIndex(x, y)][i] = calculated.get(i);
      }
      pieceMoves[1][GetIndex(x, y)] = new int[4];
      pieceMoves[3][GetIndex(x, y)] = new int[8];
      for (int i=0; i<4; i++) {
        for (int m=1; m<8; m++) {
          int cx = x+m*otherFaces[i][0];
          int cy = y+m*otherFaces[i][1];
          if (cx==-1 || cx==8 || cy==-1 || cy==8) {
            pieceMoves[1][GetIndex(x, y)][i] = GetIndex(x, y);
            pieceMoves[3][GetIndex(x, y)][i] = GetIndex(x, y);
            break;
          }
          if (cx==0 || cx==7 || cy==0 || cy==7) {
            pieceMoves[1][GetIndex(x, y)][i] = GetIndex(cx, cy);
            pieceMoves[3][GetIndex(x, y)][i] = GetIndex(cx, cy);
            break;
          }
        }
      }
      pieceMoves[2][GetIndex(x, y)] = new int[4];
      for (int i=4; i<8; i++) {
        for (int m=1; m<8; m++) {
          int cx = x+m*otherFaces[i][0];
          int cy = y+m*otherFaces[i][1];
          if (cx==-1 || cx==8 || cy==-1 || cy==8) {
            pieceMoves[2][GetIndex(x, y)][i-4] = GetIndex(x, y);
            pieceMoves[3][GetIndex(x, y)][i] = GetIndex(x, y);
            break;
          }
          if (cx==rookLimits[i-4][0] || cy==rookLimits[i-4][1]) {
            pieceMoves[2][GetIndex(x, y)][i-4] = GetIndex(cx, cy);
            pieceMoves[3][GetIndex(x, y)][i] = GetIndex(cx, cy);
            break;
          }
        }
      }
      calculated = new ArrayList<Integer>();
      for (int i=0; i<8; i++) {
        int cx = x+otherFaces[i][0];
        int cy = y+otherFaces[i][1];
        if (cx!=-1 && cx!=8 && cy!=-1 && cy!=8) {
          calculated.add(GetIndex(cx, cy));
        }
      }
      pieceMoves[4][GetIndex(x, y)] = new int[calculated.size()];
      for (int i=0; i<calculated.size(); i++) {
        pieceMoves[4][GetIndex(x, y)][i] = calculated.get(i);
      }
      calculated = new ArrayList<Integer>();
      if (y>0) {
        calculated.add(GetIndex(x, y-1));
        if (x<7) {
          calculated.add(GetIndex(x+1, y-1));
        }
        if (x>0) {
          calculated.add(GetIndex(x-1, y-1));
        }
      }
      if (y==6) {
        calculated.add(GetIndex(x, y-2));
      }
      whitePawnMoves[GetIndex(x, y)] = new int[calculated.size()];
      for (int i=0; i<calculated.size(); i++) {
        whitePawnMoves[GetIndex(x, y)][i] = calculated.get(i);
      }
      calculated = new ArrayList<Integer>();
      if (y<7) {
        calculated.add(GetIndex(x, y+1));
        if (x<7) {
          calculated.add(GetIndex(x+1, y+1));
        }
        if (x>0) {
          calculated.add(GetIndex(x-1, y+1));
        }
      }
      if (y==1) {
        calculated.add(GetIndex(x, y+2));
      }
      blackPawnMoves[GetIndex(x, y)] = new int[calculated.size()];
      for (int i=0; i<calculated.size(); i++) {
        blackPawnMoves[GetIndex(x, y)][i] = calculated.get(i);
      }
    }
  }
}
