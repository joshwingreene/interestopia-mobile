import 'package:interestopia/models/tag.dart';

bool tagWithTitleExists({ String title, List<Tag> tags }) {
  for (int i = 0; i < tags.length; i++) {
    if (tags[i].title == title)
      return true;
  }
  return false;
}