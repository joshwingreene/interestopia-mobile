import 'package:interestopia/models/destination.dart';
import 'package:flutter/material.dart';

List<Destination> allDestinations = [
  Destination(index: 0, title: 'Listen', icon: Icons.headset, color: Colors.black), // Will likely be changed to be dependent on the associated setting in Settings
  Destination(index: 1, title: 'Search', icon: Icons.search, color: Colors.black),
  Destination(index: 2, title: 'Settings', icon: Icons.settings, color: Colors.black),
];