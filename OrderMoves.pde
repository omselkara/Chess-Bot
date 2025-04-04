float inf = 10000;

MoveList OrderMoves(Game game,MoveList moves){
  MoveList ordered = new MoveList();
  float[] moveScores = new float[moves.size()];
  for (int i=0;i<moves.size();i++){
    Move move = moves.get(i);
    float score = 0;
    if (move.promoteTo!=0){
      score += scores[GetType(move.promoteTo)-1];
    }
    if (move.atePiece!=0){
      score += scores[GetType(move.atePiece)-1]-scores[GetType(game.board[move.from])-1];
    }
    if (bestMove!=null && move.from==bestMove.from && move.to==bestMove.to){
      score += inf;
    }
    moveScores[i] = score;    
  }
  for (int step=0;step<moves.size();step++){
    float best = -inf;
    int bestIndex = -1;
    for (int index=0;index<moves.size();index++){
      if (moveScores[index]>=best){
        best = moveScores[index];
        bestIndex = index;
      }
    }
    ordered.add(moves.get(bestIndex));
    moveScores[bestIndex] = -inf;
  }
  return ordered;
}
