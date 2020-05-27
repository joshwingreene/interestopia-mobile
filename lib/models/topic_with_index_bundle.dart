import 'package:interestopia/models/topic_ui_model.dart';

class TopicWithIndexBundle { // Created in order to select topics that showed up as a search result in the search bar on the TempSavePage

  final Topic_UI_Model topic;
  final int index;

  TopicWithIndexBundle({ this.topic, this.index });
}