import 'package:flutter/material.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/screens/authenticate/authenticate.dart';
import 'package:interestopia/screens/home/home.dart';
import 'package:interestopia/screens/settings/setting.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // accesses the user data from the provider
    final user = Provider.of<User>(context);
    print(user);

    // return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Settings();
    }
  }
}
