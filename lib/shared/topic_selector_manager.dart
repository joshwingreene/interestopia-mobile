import 'package:interestopia/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:interestopia/models/topic_with_index_bundle.dart';

class TopicSelectorManager {

  List<Topic> topicList;
  int selectedTopicIndex;

  TopicSelectorManager() {
    topicList = [
      Topic(icon: Icons.brush, title: 'Arts', isOn: false),
      Topic(icon: Icons.business, title: 'Business', isOn: false),
      Topic(icon: Icons.create, title: 'Design', isOn: false),
      Topic(icon: Icons.school, title: 'Education', isOn: false),
      Topic(icon: Icons.shopping_basket, title: 'Fashion', isOn: false),
      Topic(icon: Icons.monetization_on, title: 'Finance', isOn: false),
      Topic(icon: Icons.fastfood, title: 'Food', isOn: false),
      Topic(icon: Icons.hourglass_empty, title: 'Govt', isOn: false),
      Topic(icon: Icons.healing, title: 'Health', isOn: false),
      Topic(icon: Icons.brush, title: 'Leisure', isOn: false),
      Topic(icon: Icons.brush, title: 'News', isOn: false),
      Topic(icon: Icons.brush, title: 'Religion', isOn: false),
      Topic(icon: Icons.brush, title: 'Science', isOn: false),
      Topic(icon: Icons.brush, title: 'Self', isOn: false),
      Topic(icon: Icons.brush, title: 'Society', isOn: false),
      Topic(icon: Icons.brush, title: 'Sports', isOn: false),
      Topic(icon: Icons.brush, title: 'Tech', isOn: false)
    ];
  }

  bool isATopicSelected() {
    return selectedTopicIndex != null;
  }

  List<Topic> getTopics() {
    return topicList;
  }

  Topic getTopic(int index) {
    return topicList[index];
  }

  void selectTopic(int index) {
    if (selectedTopicIndex != null) {
      topicList[selectedTopicIndex].isOn = false; // reset the previous topic
    }
    selectedTopicIndex = index; // store the newly selected topic's index
    topicList[index].isOn = true; // update the selected topic
  }

  List<TopicWithIndexBundle> findTopicsWithStr(String text) {

    List<TopicWithIndexBundle> result = [];

    for (int i = 0; i < topicList.length; i++) {
      if (topicList[i].title.toLowerCase().contains(text)) {
        result.add(TopicWithIndexBundle(topic: topicList[i], index: i));
      }
    }

    return result;
  }

  void resetSelection() {
    topicList[selectedTopicIndex].isOn = false;
    selectedTopicIndex = null;
  }
}

