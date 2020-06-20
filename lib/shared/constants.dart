import 'package:interestopia/models/destination.dart';
import 'package:flutter/material.dart';
import 'package:interestopia/models/topic_ui_model.dart';

List<Destination> allDestinations = [
  Destination(index: 0, title: 'Listen', icon: Icons.headset, color: Colors.black), // Will likely be changed to be dependent on the associated setting in Settings
  Destination(index: 1, title: 'Search', icon: Icons.search, color: Colors.black),
  Destination(index: 2, title: 'Settings', icon: Icons.settings, color: Colors.black),
];

List<Topic_UI_Model> topicList = [
  Topic_UI_Model(icon: Icons.brush, title: 'Arts'),
  Topic_UI_Model(icon: Icons.business, title: 'Business'),
  Topic_UI_Model(icon: Icons.create, title: 'Design'),
  Topic_UI_Model(icon: Icons.school, title: 'Education'),
  Topic_UI_Model(icon: Icons.shopping_basket, title: 'Fashion'),
  Topic_UI_Model(icon: Icons.monetization_on, title: 'Finance'),
  Topic_UI_Model(icon: Icons.fastfood, title: 'Food'),
  Topic_UI_Model(icon: Icons.hourglass_empty, title: 'Government'),
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