boolean bot = true; //Is bot Enabled
boolean botIsWhite = false;
int startTime;
int duration = 1000;
float lastBestScore;
Move lastBestMove;

void PlayBot(Game game) {
  if (game.whitesTurn==botIsWhite) {
    if (game.IsMate() || game.IsDraw()){
      return;
    }
    if (PlayFromBook(game)){
      return ;
    }
    startTime = millis();
    for (int i=1;i<99;i++){      
      targetDepth = i;            
      float eval = AlphaBeta(targetDepth,game,-inf,inf,0,true);
      if (millis()-startTime<duration){
        lastBestMove = bestMove;
        lastBestScore = eval;
        if (!game.whitesTurn){
          lastBestScore *= -1;
        }
        println("Eval:"+str(lastBestScore)+" Move:"+lastBestMove.GetMoveName()+" Depth:"+str(targetDepth));
      }
      else{
        targetDepth -= 1;
        break;
      }
    }
    //println("Eval:"+str(lastBestScore)+" Move:"+lastBestMove.GetMoveName()+" Depth:"+str(targetDepth));
    PlayMove(lastBestMove);
    //bestMove = null;
  } else {
    println("Benim sıram değil");
  }
}

boolean PlayFromBook(Game game){
  ArrayList<Integer> indexes = new ArrayList<>();
  int index = 0;
  for (String[] moveLines : opening){
    if (uciMoves.size()==moveLines.length){
      index++;
      break;
    }
    boolean ok = true;
    for (int i=0;i<uciMoves.size();i++){      
      if (!moveLines[i].equals(uciMoves.get(i))){
        ok = false;
        break;
      }
    }
    if (ok){
      indexes.add(index);
    }
    index++;
  }
  if (indexes.size()>0){    
    index = (int) random(0,indexes.size());
    String moveName = opening[indexes.get(index)][uciMoves.size()];
    MoveList moves = game.MoveGenerator(true);
    for (Move move : moves){
      if (move.GetMoveName().equals(moveName)){
        PlayMove(move);
        return true;
      }
    }
    println("hata var açılışta");
  }
  return false;
}
