import 'package:flutter/material.dart';
import 'package:interestopia/services/auth.dart';

class Home extends StatelessWidget { // Listen/Read tab

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Center(
            child: RaisedButton(
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 20.0,
                    )
                )),
          ),
        ),
      ),
    );
  }
}
