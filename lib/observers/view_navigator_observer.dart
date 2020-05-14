import 'package:flutter/material.dart';

class ViewNavigatorObserver extends NavigatorObserver {

  final VoidCallback onNavigation;

  ViewNavigatorObserver(this.onNavigation);

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
}