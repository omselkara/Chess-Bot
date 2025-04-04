final int FOUND = 0;
final int ALPHA = 1;
final int BETA = 2;

final int size = 100000000;

Result[] table;

void ClearTable(){
  table = new Result[size];
}

int GetKey(long hash){
  if (hash<0){
    return (int)((~hash+1)%size);
  }
  return (int)(hash%size);
}

class Result{
  long hash;
  float score;
  int type;
  int depth;
  boolean isMax;
}
