import java.util.Iterator;

int limit = 100;

public class MoveList implements Iterable<Move> {
  Move[] moves;
  int count;

  public MoveList() {
    moves = new Move[limit];
    count = 0;
  }
  
  void add(Move move){
    moves[count] = move;
    count++;
  }
  
  int size(){
    return count;
  }
  
  Move get(int index){
    return moves[index];
  }

  // Iterable arayüzü için gerekli metodu uygulayalım
  @Override
  public Iterator<Move> iterator() {
    return new MovesIterator();
  }

  // Özel bir Iterator sınıfı oluşturalım
  private class MovesIterator implements Iterator<Move> {
    private int index = 0;

    @Override
    public boolean hasNext() {
      return index < count;
    }

    @Override
    public Move next() {
      return moves[index++];
    }
  }
}
