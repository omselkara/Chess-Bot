class RepetetionTable {
  ArrayList<Long> list;
  RepetetionTable(){
    list = new ArrayList<>();
  }
  boolean IsDraw(long hashValue){
    int count = countOccurrences(hashValue);
    return count>=3;
  }
  
  void add(long hashValue){
    list.add(hashValue);
  }
  
  long get(int index){
    return list.get(index);
  }
  
  void remove(int index){
    list.remove(index);
  }
  
  void pop(){
    if (list.size()>0){
      list.remove(list.size()-1);
    }
  }

  public int countOccurrences(Long hashValue) {
    return (int) (list.stream().filter(item -> item.equals(hashValue)).count());
  }
}
