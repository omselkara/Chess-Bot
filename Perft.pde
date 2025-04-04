int depth = 5;
long Perft(int step,Game game){
  MoveList moves = game.MoveGenerator(true);
  if (step==depth){
    return moves.size();
  }
  long count = 0;
  for (Move move : moves){
    game.MakeMove(move);
    count += Perft(step+1,game);
    game.UndoMove(move);
  }
  return count;
}
