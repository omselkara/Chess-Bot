float MinMax(int depth,Game game,boolean isMax,String string){
  if (depth==0){
    return game.Evaluate();
  }
  MoveList moves = game.MoveGenerator(true);
  if (isMax){
    float best = -inf;
    for (Move move : moves){
      game.MakeMove(move);
      float value = MinMax(depth-1,game,false,string+move.GetMoveName()+" ");
      game.UndoMove(move); 
      best = max(value,best);
    }
    return best;
  }
  else{
    float best = inf;
    for (Move move : moves){
      game.MakeMove(move);
      float value = MinMax(depth-1,game,true,string+move.GetMoveName()+" ");
      game.UndoMove(move);
      best = min(value,best);
    }
    return best;
  }
}
