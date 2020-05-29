import 'tag.dart';

class Tag_UI_Model extends Tag {
  bool isSelected = false;

  Tag_UI_Model({String id, String title}) {
    this.id = id;
    this.title = title;
  }
}