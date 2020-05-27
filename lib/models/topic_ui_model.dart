import 'topic.dart';
import 'package:flutter/material.dart';

class Topic_UI_Model extends Topic {
  bool isOn = false;

  Topic_UI_Model({ String title, IconData icon }) {
    this.title = title;
    this.icon = icon;
  }
}