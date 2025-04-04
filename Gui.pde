float dx;
Game game;
color[] boardColors = new color[] {color(240, 217, 181), color(181, 136, 99), color(205, 210, 106), color(170, 162, 58), color(130, 151, 105), color(100, 111, 64)};
PImage[] pieceImages = new PImage[12];
boolean pressed = false;
int clickX = -1;
int clickY = -1;
ArrayList<Move> moves = new ArrayList<Move>();
boolean edit = false;
boolean promoting = false;
Move promoteMove;
int movedAt = 0;
int Width = 800;
int Height = 800;
ArrayList<String> uciMoves = new ArrayList<>();

void DrawBoard() {
  MoveList canMove = new MoveList();
  if (pressed) {
    canMove = game.GenerateMovesAt(GetIndex(clickX, clickY),true);
  }
  strokeWeight(0);
  for (int y=0; y<8; y++) {
    for (int x=0; x<8; x++) {
      int index = GetIndex(x, y);
      int colorIndex = (y%2+x%2)%2;
      if (pressed && x==clickX && y==clickY) {
        colorIndex += 4;
      } else if (moves.size()>0) {
        Move move = moves.get(moves.size()-1);
        if (move.from==index || move.to==index) {
          colorIndex += 2;
        }
      }
      fill(boardColors[colorIndex]);
      rect(x*dx, y*dx, dx, dx);
      if (pressed) {
        for (Move move : canMove) {
          if (move.to==GetIndex(x, y)) {
            if (game.board[move.to]!=0) {
              fill(boardColors[(y%2+x%2)%2+4]);
              rect(x*dx, y*dx, dx,dx);
              fill(boardColors[(y%2+x%2)%2]);
              ellipse(x*dx+dx/2, y*dx+dx/2, dx, dx);
            } else {
              fill(boardColors[(y%2+x%2)%2+4]);
              ellipse(x*dx+dx/2, y*dx+dx/2, dx/4, dx/4);
            }
          }
        }
      }
      if (game.board[index]!=0 &&(!pressed || clickX!=x || clickY!=y)) {
        image(pieceImages[game.board[index]-1], x*dx, y*dx, dx, dx);
      }
    }
  }
  if (pressed) {
    image(pieceImages[game.board[GetIndex(clickX, clickY)]-1], mouseX-dx/2, mouseY-dx/2, dx, dx);
  }
  if (promoting){
    fill(0,0,0,128);
    rect(0,0,Width,Height);
    if (game.whitesTurn){
      fill(0);
    }
    else{
      fill(255);
    }
    rect(2*dx,3.5*dx,4*dx,dx);
    fill(168);
    for (int i=0;i<4;i++){
      ellipse((2.5+i)*dx,4*dx,dx,dx);
      if (game.whitesTurn){        
        image(pieceImages[promotePieces[i]-1],(2+i)*dx,3.5*dx,dx,dx);
      }
      else{
        image(pieceImages[promotePieces[i]+5],(2+i)*dx,3.5*dx,dx,dx);
      }
    }
  }
  if (edit) {
    textAlign(CENTER, CENTER);
    textSize(dx/1.5);
    fill(0);
    textSize(dx);
    fill(0);
    int x = GetX(game.whiteKingIndex);
    int y = GetY(game.whiteKingIndex);
    text(game.whiteKingIndex, x*dx+dx/2, y*dx+dx/4);
    fill(255);
    x = GetX(game.blackKingIndex);
    y = GetY(game.blackKingIndex);
    text(game.blackKingIndex, x*dx+dx/2, y*dx+dx/4);
    if (pressed) {
      /*if (GetType(game.board[GetIndex(clickX,clickY)])==pawn){
       if (IsWhite(game.board[GetIndex(clickX,clickY)])){
       for (int index : whitePawnMoves[GetIndex(clickX,clickY)]){
       x = GetX(index);
       y = GetY(index);
       ellipse(x*dx+dx/2,y*dx+dx/2,dx/2,dx/2);
       }
       }
       else{
       for (int index : blackPawnMoves[GetIndex(clickX,clickY)]){
       x = GetX(index);
       y = GetY(index);
       ellipse(x*dx+dx/2,y*dx+dx/2,dx/2,dx/2);
       }
       }
       }
       if (GetType(game.board[GetIndex(clickX,clickY)])==knight){
       for (int index : pieceMoves[0][GetIndex(clickX,clickY)]){
       x = GetX(index);
       y = GetY(index);
       ellipse(x*dx+dx/2,y*dx+dx/2,dx/2,dx/2);
       }
       }
       if (GetType(game.board[GetIndex(clickX,clickY)])==bishop){
       for (int i=0;i<4;i++){
       int index = GetIndex(clickX,clickY);
       while (index!=pieceMoves[1][GetIndex(clickX,clickY)][i]){
       index += faces[i];
       x = GetX(index);
       y = GetY(index);
       ellipse(x*dx+dx/2,y*dx+dx/2,dx/2,dx/2);
       }
       }
       }
       if (GetType(game.board[GetIndex(clickX,clickY)])==rook){
       for (int i=4;i<8;i++){
       int index = GetIndex(clickX,clickY);
       while (index!=pieceMoves[2][GetIndex(clickX,clickY)][i-4]){
       index += faces[i];
       x = GetX(index);
       y = GetY(index);
       ellipse(x*dx+dx/2,y*dx+dx/2,dx/2,dx/2);
       }
       }
       }
       if (GetType(game.board[GetIndex(clickX,clickY)])==queen){
       for (int i=0;i<8;i++){
       int index = GetIndex(clickX,clickY);
       while (index!=pieceMoves[3][GetIndex(clickX,clickY)][i]){
       index += faces[i];
       x = GetX(index);
       y = GetY(index);
       ellipse(x*dx+dx/2,y*dx+dx/2,dx/2,dx/2);
       }
       }
       }
       if (GetType(game.board[GetIndex(clickX,clickY)])==king){
       for (int index : pieceMoves[4][GetIndex(clickX,clickY)]){
       x = GetX(index);
       y = GetY(index);
       ellipse(x*dx+dx/2,y*dx+dx/2,dx/2,dx/2);
       }
       }*/
    }
  }
}

void mousePressed() {
  if (!promoting){
    int x = (int) (mouseX/dx);
    int y = (int) (mouseY/dx);
    pressed = (x>=0 && x<8 && y>=0 && y<8 && game.board[GetIndex(x, y)]!=0 && IsWhite(game.board[GetIndex(x, y)])==game.whitesTurn);
    clickX = x;
    clickY = y;
  }
}
void mouseReleased() {
  int x = (int) (mouseX/dx);
  int y = (int) (mouseY/dx);
  if (promoting){
    float x2 = mouseX/dx;
    float y2 = mouseY/dx;
    if (y2>=3.5 && y2<=4.5 && x2>=2 && x2<=6){
      if (x2>=2 && x2<=3){
        promoteMove.promoteTo = (game.whitesTurn ? white:black)+promotePieces[0];
      }
      else if (x2>=3 && x2<=4){
        promoteMove.promoteTo = (game.whitesTurn ? white:black)+promotePieces[1];
      }
      else if (x2>=4 && x2<=5){
        promoteMove.promoteTo = (game.whitesTurn ? white:black)+promotePieces[2];
      }
      else if (x2>=5 && x2<=6){
        promoteMove.promoteTo = (game.whitesTurn ? white:black)+promotePieces[3];
      }
      PlayMove(promoteMove);
    }
    promoting = false;
  }
  else if (pressed && x>=0 && x<8 && y>=0 && y<8 && (x!=clickX || y!=clickY)) {    
    MoveList canMove = game.GenerateMovesAt(GetIndex(clickX, clickY),true);
    for (Move move : canMove) {
      if (move.from==GetIndex(clickX, clickY) && move.to==GetIndex(x, y)) {
        if (move.promoteTo!=0){
          promoting = true;
          promoteMove = move;
        }
        else{
          PlayMove(move);    
        }
        break;
      }
    }
  }
  pressed = false;
}

void keyPressed() {
  if (key=='z') {
    promoting = false;
    if (bot){
      if (moves.size()>1) {
        game.UndoMove(moves.get(moves.size()-1));
        moves.remove(moves.size()-1);
        game.UndoMove(moves.get(moves.size()-1));
        moves.remove(moves.size()-1);
        uciMoves.remove(uciMoves.size()-1);
        uciMoves.remove(uciMoves.size()-1);
      }
    }
    else{
      if (moves.size()>0) {
        game.UndoMove(moves.get(moves.size()-1));
        moves.remove(moves.size()-1);
        uciMoves.remove(uciMoves.size()-1);
      }
    }
  }
}

void PlayMove(Move move){
  delay(100);
  game.MakeMove(move);
  moves.add(move);
  if (move.atePiece!=0) {
    captureSound.play();
  } else {
    moveSound.play();
  }
  uciMoves.add(move.GetMoveName());
  movedAt = millis();
}

int GetIndex(int x, int y) {
  return y*8+x;
}

int GetX(int index) {
  return index%8;
}

int GetY(int index) {
  return index/8;
}
