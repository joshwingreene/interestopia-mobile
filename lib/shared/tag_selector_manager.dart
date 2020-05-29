import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/tag_ui_model.dart';

class TagSelectorManager {

  List<Tag_UI_Model> tagList = [];

  TagSelectorManager({ List<Tag> tags }) {

    if (tags == null) {
      print('tags is null');
    }

    for (int i = 0; i < tags.length; i++) {
      print('tag: ' + tags[i].title);
    }

    tagList = tags.map((tag) => Tag_UI_Model(id: tag.id, title: tag.title)).toList();
  }

  void updateTags({ List<Tag> tags }) {
    // go through tags

    // check if its title can be found (issue: can I ensure items maintain their index?)(I don't think so based on what's going on with the search search screen)

    // if no, create a Tag_UI its id

    // the above is a n2 operation

    // -- alternate (going with this)

    // use the getSelectedIds method

    // recreate the list as usual

    // go through the selected list and manually call the select method

    tagList = tags.map((tag) => Tag_UI_Model(id: tag.id, title: tag.title)).toList();

    List<String> selectedTagIds = getSelectedTagIds();

    for (int i = 0; i < selectedTagIds.length; i++) {
      for (int j = 0; j < tagList.length; j++) {
        if (tagList[j].id == selectedTagIds[i]) {
          tagList[j].isSelected = true;
        }
      }
    }
  }

  void addIdToTag({ int index, String id }) {
    tagList[index].id = id;
  }

  void resetTagList() {
    tagList = [];
  }

  Tag_UI_Model getTag({int index}) {
    return tagList[index];
  }

  void addTag({ Tag_UI_Model tag }) {
    tagList.add(tag);
  }

  void selectTag({int index}) {
    tagList[index].isSelected = !tagList[index].isSelected;
  }


  List<String> getSelectedTagIds() {
    List<String> result = [];

    for (int i = 0; i < tagList.length; i++) {
      if (tagList[i].isSelected) {
        result.add(tagList[i].id);
        //print('add tag');
      }
    }
    return result;
  }

  int getNumberOfTags() {
    return tagList != null ? tagList.length : 0;
  }
}