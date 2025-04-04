class SearchResult{
  float score;
  String moves;
  int depth;
  SearchResult(float score,String moves,int depth){
    this.score = score;
    this.moves = moves;
    this.depth = depth;
  }
}
