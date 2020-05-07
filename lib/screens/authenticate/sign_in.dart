import 'package:flutter/material.dart';
import 'package:interestopia/screens/authenticate/register.dart';
import 'package:interestopia/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Sign into Interestopia')
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
        child: Column(
          children: <Widget>[
              Expanded(
                flex: 5,
                child: Form(
                  key: _formKey, // allows us to track the state of our form
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        )
                      ),
                      SizedBox(
                        height: 50
                      ),
                      TextFormField(
                          validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          )
                      ),
                      SizedBox(
                          height: 12
                      ),
                      Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)
                      ),
                      SizedBox(
                        height: 50
                      ),
                      RaisedButton(
                        color: Colors.deepPurpleAccent,
                        onPressed: () async {
                          // Sign In with Email and Password
                          if (_formKey.currentState.validate()) { // will only be valid if the above validate properties receive a value of null
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() => error = 'Could not sign in with those credentials');
                            } else {
                              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false); // think this will do the job - https://stackoverflow.com/questions/52048101/how-to-reset-the-base-route-in-my-flutter-app-that-is-pop-any-routes-and-repla
                            }
                          }

                          // Anonymouse Sign-In
                          /*
                          dynamic result = await _auth.signInAnon();
                          if (result == null) {
                            print('error signing in');
                          } else {
                            print('signed in');
                            print(result.uid);
                          }
                          */
                        },
                        child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white)
                        )
                      ),
                      SizedBox(
                          height: 10
                      ),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel')
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () => print('Forget Password'),
                  child: Text('Forget Password')
                ),
              )
              ],
        ),
      ),
    );
  }
}
