import 'package:flutter/material.dart';
import 'package:interestopia/screens/authenticate/register.dart';
import 'package:interestopia/screens/authenticate/sign_in.dart';
import 'package:interestopia/screens/authenticate/splash.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Splash(),
    );
  }
}
