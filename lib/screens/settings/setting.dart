import 'package:flutter/material.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/auth.dart';
import 'package:interestopia/services/database.dart';
import 'package:interestopia/shared/loading.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    // accesses the user data from the provider
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
                title: Text(
                    'Interestopia',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent
                    )
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      child: Text(
                          'Log out',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0
                          )
                      )
                  ),
                ],
              ),
              body: Container(
                  color: Colors.grey[300],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                        child: Text(
                            'Account',
                            style: TextStyle(
                                fontSize: 20
                            )
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(userData.name),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      )
                    ],
                  )
              )
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
