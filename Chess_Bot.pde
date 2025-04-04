import processing.sound.*;
SoundFile moveSound, captureSound;
String[][] opening;

void setup() {
  String[] lines = loadStrings("Pos.txt");
  opening = new String[lines.length][];
  for (int i=0;i<lines.length;i++){
    String line = lines[i];
    opening[i] = line.split(" ");
  }
  PrepareMoves();
  Zobrist.Setup();
  size(1050, 800);
  frameRate(144);  
  dx = Width/8f;
  game = new Game();
  //botIsWhite = game.whitesTurn;
  ClearTable();
  pieceImages[0] = loadImage("Pieces/white-pawn.png");
  pieceImages[1] = loadImage("Pieces/white-knight.png");
  pieceImages[2] = loadImage("Pieces/white-bishop.png");
  pieceImages[3] = loadImage("Pieces/white-rook.png");
  pieceImages[4] = loadImage("Pieces/white-queen.png");
  pieceImages[5] = loadImage("Pieces/white-king.png");
  pieceImages[6] = loadImage("Pieces/black-pawn.png");
  pieceImages[7] = loadImage("Pieces/black-knight.png");
  pieceImages[8] = loadImage("Pieces/black-bishop.png");
  pieceImages[9] = loadImage("Pieces/black-rook.png");
  pieceImages[10] = loadImage("Pieces/black-queen.png");
  pieceImages[11] = loadImage("Pieces/black-king.png");
  moveSound = new SoundFile(this, "Sounds/move-self.mp3");
  captureSound = new SoundFile(this, "Sounds/capture.mp3");
  movedAt = millis();
  /*for (int i=0;i<7;i++){
    int time = millis();
    depth = i;
    long count = Perft(0,game);
    println(str(i+1)+"  "+str((int)count)+ "  " +str((millis()-time)/1000.0f));
  }*/
}
void draw() {
  background(0);
  DrawBoard();
  if (bot && game.whitesTurn==botIsWhite){
    if (millis()-movedAt>50){
      PlayBot(game);      
    }
  }
  fill(255);
  textSize(40);
  textAlign(LEFT);
  text("Depth:"+str(targetDepth),Width+10,50);
  text("Eval:"+str(round(lastBestScore*100f)/100f),Width+10,150);
}
