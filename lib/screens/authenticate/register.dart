import 'package:flutter/material.dart';
import 'package:interestopia/services/auth.dart';
import 'package:interestopia/shared/loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  String email = '';
  String password = '';

  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('Join Interestopia')
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
        child: Form(
          key: _formKey, // allows us to track the state of our form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  validator: (val) => val.isEmpty ? 'Enter your name' : null,
                  onChanged: (val) {
                    setState(() => name = val);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  )
              ),
              SizedBox(
                  height: 50
              ),
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
                  height: 25
              ),
              Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0)
              ),
              SizedBox(
                  height: 25
              ),
              RaisedButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) { // will only be valid if the above validate properties receive a value of null
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithNameEmailAndPassword(name, email, password);
                      if (result == null) {
                        setState(() {
                          error = 'please supply a valid email';
                          loading = false;
                        });
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false); // removes all of the previous routes on the stack-  https://stackoverflow.com/questions/52048101/how-to-reset-the-base-route-in-my-flutter-app-that-is-pop-any-routes-and-repla
                      }
                    }
                  },
                  child: Text(
                      'Register',
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
    );
  }
}
