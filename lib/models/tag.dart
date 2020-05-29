class Tag {

  String id;
  String title;
  List<dynamic> associatedItemIds = []; // list of item ids

  Tag({ this.id, this.title, this.associatedItemIds });

  int getNumberOfItems() {
    return associatedItemIds.length;
  }
}