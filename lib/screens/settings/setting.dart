import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/auth.dart';
import 'package:interestopia/services/database.dart';
import 'package:interestopia/shared/loading.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {

  const Settings({ this.destination }); // removed the key stuff in order to remove that Global key error

  final Destination destination;

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
                leading: MaterialButton(
                  onPressed: () => Navigator.pushNamed(context, '/save'),
                  child: Icon(Icons.add)
                ),
                elevation: 0.0,
                backgroundColor: Colors.white,
                brightness: Theme.of(context).brightness,
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
                      ),
                      SizedBox(
                        height: 20
                      ),
                      RaisedButton(
                        color: Colors.deepPurpleAccent,
                        onPressed: () {
                          /*
                          DatabaseService(uid: userData.uid).postNewSavedItem(
                              'The Cost of Javascript Frameworks - Web Performance Consulting',
                              DateTime.now(),
                              '',
                              'Technology');
                          DatabaseService(uid: userData.uid).postNewSavedItem(
                              'Most College Graduates Wish They Majored in Something Different',
                              DateTime.now(),
                              'Three out of five college graduates say they should have majored in something different and would go back and change their field of study',
                              'Education');
                          DatabaseService(uid: userData.uid).postNewSavedItem(
                              'Opinion | Black Britons Know Why Meghan Markle Wants Out',
                              DateTime.now(),
                              'It\’s the racism.',
                              'Goverment');
                          DatabaseService(uid: userData.uid).postNewSavedItem(
                              '8 tips for more productive meetings',
                              DateTime.now(),
                              'Studies have shown unproductive meetings waste over \$36 YoY.',
                              'Goverment');
                          DatabaseService(uid: userData.uid).postNewSavedItem(
                              'Scientists Are Starting to Take Warp Drives Seriously, Especially One Specific Concept',
                              DateTime.now(),
                              'The detection of gravitational waves changed things.',
                              'Science');
                          DatabaseService(uid: userData.uid).postNewSavedItem(
                              'Experts demolish studies suggesting COVID-19 is no worse than flu',
                              DateTime.now(),
                              'Authors of widely publicized antibody studies \“owe us all an apology,\” one expert says.',
                              'Health');
                          DatabaseService(uid: userData.uid).postNewSavedItem(
                              'Meet The 28-Year-Old Mexican Woman Who Has Just Been Named Best Chef In The World',
                              DateTime.now(),
                              'Mexican-born New York chef Daniela Soto-Innes has just been named the world\’s best female chef at the age of 28.',
                              'Food');

                           */
                        },
                        child: Text(
                            'Add Temp Data',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                            )
                        )
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
