class Tag {

  String title;
  List<String> itemsWithThisTag = []; // list of item ids

  Tag({ this.title });

  int getNumberOfItems() {
    return itemsWithThisTag.length;
  }
}