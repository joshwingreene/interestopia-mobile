import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/auth.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final AuthService _auth = AuthService();
  List<SavedItem> savedItems = [];

  Future<List<SavedItem>> _getAllItems(String text) async {

    List<SavedItem> items = [
      SavedItem(title: 'one', dateTimeSaved: DateTime.now(), description: '', topic: 'design'),
      SavedItem(title: 'two', dateTimeSaved: DateTime.now(), description: '', topic: 'education'),
      SavedItem(title: 'three', dateTimeSaved: DateTime.now(), description: '', topic: 'technology')
    ];

    return items;
  }

  Future getSavedItems(String uid) async {

    return await DatabaseService(uid: uid).getSavedItemListFromFirebase();
  }

  FlatButton buildClickableListItem(int index, [SavedItem item]) {
    return FlatButton(
      onPressed: () => print('Item Pressed'),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item != null ? item.title : savedItems[index].title,
                    ),
                    Text(
                      'medium.com',
                      style: TextStyle(
                        color: Colors.grey[500]
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Image.asset('images/temp.png')
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // accesses the user data from the provider
    final user = Provider.of<User>(context);

    if (savedItems.length == 0) {
        getSavedItems(user.uid).then((list) {
          //print('List: ' + list.toString());
          setState(() {
            savedItems = list;
          });
        });
    }

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                ],
              )
            ),
            Expanded( // The quick, baby pool fix is to change the mainAxisSize of theRow/Column to MainAxisSize.min, then wrap the child that wants to be infinitely large in an Expanded. - https://medium.com/flutter-community/flutter-deep-dive-part-1-renderflex-children-have-non-zero-flex-e25ffcf7c272
              flex: 15,
              child: SearchBar( // What's being done with the placeholder property is just being done temporarily. This will fetch a specific number of the most recently saved items. If the user scrolls, it will fetch more.
                placeHolder: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return buildClickableListItem(index);
                    },
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemCount: savedItems.length),
                hintText: 'Enter title',
                searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
                headerPadding: EdgeInsets.symmetric(horizontal: 10),
                listPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                icon: Icon(Icons.search),
                onSearch: _getAllItems,
                onItemFound: (SavedItem item, int index) {
                  return buildClickableListItem(index, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
