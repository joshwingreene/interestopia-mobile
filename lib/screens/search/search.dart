import 'package:flutter/material.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/auth.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final AuthService _auth = AuthService();
  List<ListTile> savedItems = [];

  Future getSavedItems(String uid) async {

    return await DatabaseService(uid: uid).getSavedItemListFromFirebase();
  }

  @override
  Widget build(BuildContext context) {

    // accesses the user data from the provider
    final user = Provider.of<User>(context);

    if (savedItems.length == 0) {
        getSavedItems(user.uid).then((list) {
          //return list;
          print('List: ' + list.toString());

          List<SavedItem> tempList = list;

          List<ListTile> tileList = tempList.map((item) {
            return ListTile(
                title: Text(item.title)
            );
          }).toList();

          setState(() {
            savedItems = tileList;
          });
        });
    }
    
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                          width: 10
                      ),
                      RaisedButton(
                          onPressed: () => print('Consumption vs Reference Toggle'),
                          child: Text(
                              'For Consumption',
                              style: TextStyle(
                                  color: Colors.white
                              )),
                          color: Colors.deepPurpleAccent
                      ),
                      SizedBox(
                          width: 10
                      ),
                      RaisedButton(
                          onPressed: () => print('Sort based on dataSaved'),
                          child: Text(
                              'Newest First',
                              style: TextStyle(
                                  color: Colors.white
                              )
                          ),
                          color: Colors.deepPurpleAccent
                      ),
                      SizedBox(
                          width: 10
                      ),
                      RaisedButton(
                          onPressed: () => print('Consumption vs Reference Toggle'),
                          child: Text('Tags'),
                          color: Colors.white
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter title or use an option above',
                        )
                    ),
                  ),
                ],
              )
            ),
            Expanded(
              flex: 5,
              child: ListView(
                padding: EdgeInsets.all(8),
                children: savedItems,
              )
            )
          ],
        ),
      ),
    );
  }
}
