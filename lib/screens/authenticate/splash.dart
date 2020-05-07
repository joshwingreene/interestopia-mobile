import 'package:flutter/material.dart';
import 'package:interestopia/screens/authenticate/register.dart';
import 'package:interestopia/screens/authenticate/sign_in.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('Interestopia')
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              RaisedButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Container(
                      child: Text(
                          'Log In',
                          style: TextStyle(color: Colors.white)
                      )
                  )
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(),
                            settings: RouteSettings(name: '/signin')));
                  },
                  child: Container(
                      child: Text(
                          'Create Account'
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
