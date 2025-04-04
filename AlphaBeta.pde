int targetDepth = 1;
int extensionLimit = 4;
float mate = -1000;

Move bestMove;

float AlphaBeta(int depth, Game game, float alpha, float beta,int extension,boolean start) {
  if (millis()-startTime>=duration) {
    return 0;
  }
  if (game.IsDraw()){
    RecordHash(depth-extension, game, 0, FOUND);
    return 0;
  }
  int hashf = ALPHA;
  float val = ProbeHash(depth-extension, game, alpha, beta);
  if (depth!=targetDepth && val != inf) return val; 
  MoveList moves = game.MoveGenerator(true);
  if (moves.size()==0){
    float eval = 0;
    if (game.IsCheck()){
      eval = mate+(targetDepth-(depth-extension));
    }
    RecordHash(depth-extension, game, eval, FOUND);
    return eval;
  }
  if (depth <= 0) {
    val = Quies(depth,game,alpha,beta);//game.Evaluate();
    RecordHash(depth-extension, game, val, FOUND);
    return val;
  }
  moves = OrderMoves(game,moves);
  for (Move move : moves) {
    if (millis()-startTime>=duration) {
      return 0;
    }
    game.MakeMove(move);
    /*if (extension<extensionLimit && (move.atePiece!=0 || game.IsCheck())){
      val = -AlphaBeta(depth, game, -beta, -alpha,extension+1,false);
    }
    else{*/
      val = -AlphaBeta(depth - 1, game, -beta, -alpha,extension,false);
    //}
    game.UndoMove(move);
    if (val >= beta) {
      RecordHash(depth-extension, game, beta, BETA);
      return beta;
    }
    if (start) {
      //println(move.GetMoveName());
    }
    if (val > alpha) {
      if (start) {
        bestMove = move;
      }
      hashf = FOUND;
      alpha = val;
    }
  }
  RecordHash(depth-extension, game, alpha, hashf);
  return alpha;
}
float Quies(int depth, Game game, float alpha, float beta) {
  if (millis()-startTime>=duration) {
    return 0;
  }
  if (game.whiteCount+game.blackCount==2){
    RecordHash(depth, game, 0, FOUND);
    return 0;
  }
  int hashf = ALPHA;
  float val = ProbeHash(depth, game, alpha, beta);
  if (val != inf) return val;  
  MoveList moves = game.MoveGenerator(true);
  if (moves.size()==0){
    float eval = 0;
    if (game.IsCheck()){
      eval = -inf-depth;
    }
    RecordHash(depth, game, eval, FOUND);
    return eval;
  }
  val = game.Evaluate();
  if (val >= beta){
    RecordHash(depth, game, beta, BETA);
    return beta;
  }

  if (val > alpha){
    hashf = FOUND;
    alpha = val;
  }
  moves = OrderMoves(game,moves);
  for (Move move : moves) {
    if (millis()-startTime>=duration) {
      return 0;
    }
    if (move.atePiece!=0){
      game.MakeMove(move);
      val = -Quies(depth - 1, game, -beta, -alpha);
      game.UndoMove(move);
      if (val >= beta) {
        RecordHash(depth, game, beta, BETA);
        return beta;
      }
      if (val > alpha) {
        hashf = FOUND;
        alpha = val;
      }
    }
  }
  RecordHash(depth, game, alpha, hashf);
  return alpha;
}

float ProbeHash(int depth, Game game, float alpha, float beta) {

  Result phashe = table[GetKey(game.hashValue)];
  if (phashe==null) return inf;
  if (phashe.hash == game.hashValue) {
    if (phashe.depth >= depth) {
      if (phashe.type == FOUND) return phashe.score;
      if ((phashe.type == ALPHA) && (phashe.score <= alpha)) return alpha;
      if ((phashe.type == BETA) && (phashe.score >= beta)) return beta;
    }
  }
  return inf;
}



void RecordHash(int depth, Game game, float val, int hashf) {
  if (val!=inf && val!=-inf){
    Result phashe = new Result();
    phashe.hash = game.hashValue;
    phashe.score = val;
    phashe.type = hashf;
    phashe.depth = depth;
    table[GetKey(game.hashValue)] = phashe;
  }
}
