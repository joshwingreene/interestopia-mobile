import 'package:flutter/material.dart';

class Destination {

  final int index;
  final String title;
  final IconData icon;
  final Color color; //TODO: We should remove this since it isn't being used

  Destination({ this.index, this.title, this.icon, this.color });
}