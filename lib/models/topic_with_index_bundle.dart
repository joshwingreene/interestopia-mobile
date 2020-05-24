import 'package:interestopia/models/topic.dart';

class TopicWithIndexBundle { // Created in order to select topics that showed up as a search result in the search bar on the TempSavePage

  final Topic topic;
  final int index;

  TopicWithIndexBundle({ this.topic, this.index });
}