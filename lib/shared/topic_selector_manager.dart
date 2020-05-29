import 'package:interestopia/models/topic_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:interestopia/models/topic_with_index_bundle.dart';

class TopicSelectorManager {

  int selectedTopicIndex;
  List<Topic_UI_Model> topicList = [
    Topic_UI_Model(icon: Icons.brush, title: 'Arts'),
    Topic_UI_Model(icon: Icons.business, title: 'Business'),
    Topic_UI_Model(icon: Icons.create, title: 'Design'),
    Topic_UI_Model(icon: Icons.school, title: 'Education'),
    Topic_UI_Model(icon: Icons.shopping_basket, title: 'Fashion'),
    Topic_UI_Model(icon: Icons.monetization_on, title: 'Finance'),
    Topic_UI_Model(icon: Icons.fastfood, title: 'Food'),
    Topic_UI_Model(icon: Icons.hourglass_empty, title: 'Govt'),
    Topic_UI_Model(icon: Icons.healing, title: 'Health'),
    Topic_UI_Model(icon: Icons.brush, title: 'Leisure'),
    Topic_UI_Model(icon: Icons.brush, title: 'News'),
    Topic_UI_Model(icon: Icons.brush, title: 'Religion'),
    Topic_UI_Model(icon: Icons.brush, title: 'Science'),
    Topic_UI_Model(icon: Icons.brush, title: 'Self'),
    Topic_UI_Model(icon: Icons.brush, title: 'Society'),
    Topic_UI_Model(icon: Icons.brush, title: 'Sports'),
    Topic_UI_Model(icon: Icons.brush, title: 'Tech')
  ];

  bool isATopicSelected() {
    return selectedTopicIndex != null;
  }

  String getNameOfSelectedTopic() {
    return topicList[selectedTopicIndex].title;
  }

  List<Topic_UI_Model> getTopics() {
    return topicList;
  }

  Topic_UI_Model getTopic(int index) {
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
      if (topicList[i].title.toLowerCase().contains(text.toLowerCase())) {
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

