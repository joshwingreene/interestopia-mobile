import 'package:interestopia/models/tag_ui_model.dart';

class TagSelectorManager {

  List<Tag_UI_Model> tagList = [];

  Tag_UI_Model getTag({int index}) {
    return tagList[index];
  }

  void addTag({ Tag_UI_Model tag }) {
    tagList.add(tag);
  }

  void selectTag({int index}) {
    tagList[index].isSelected = !tagList[index].isSelected;
  }

  int getNumberOfTags() {
    return tagList.length;
  }
}