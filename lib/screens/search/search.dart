import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/auth.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class Search extends StatefulWidget {

  const Search({ Key key, this.destination }) : super(key: key);

  final Destination destination;

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

  void tapConsumptionVsReferenceToggle() {
    print('For Consumption vs Reference toggle'); // Don't forget that users will be able to select an All/Both option as well
  }

  void tapDateTimeSortToggle() {
    print('DateTimeSaved toggle');
  }

  void tapTagSelector() { // Should support multiple tags being selected
    print('Tag Selector button');
  }

  void tapTopicSelector() { // Only support one topic being selected
    print('Topic Selector button');
  }

  void tapMediaTypeSelector() { // Only support one media type being selected
    print('Media Type Selector button');
  }

  void tapFavoritedToggle() {
    print('Favorited toggle');
  }

  void tapArchivedToggle() {
    print('Archived toggle');
  }

  FlatButton buildHorizontalOptionButton({String title, bool hasCaret, bool hasStartingValue, IconData icon, Function f}) {
    return FlatButton(
      color: hasStartingValue ? Colors.deepPurpleAccent : Colors.transparent,
      onPressed: () => f(),
      child: hasCaret ? Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: hasStartingValue ? Colors.white : Colors.deepPurpleAccent),
          ),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, color: hasStartingValue ? Colors.white : Colors.deepPurpleAccent)
        ],
      ) : Icon(
          icon,
          color: Colors.deepPurpleAccent,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: hasStartingValue ? Colors.transparent : Colors.deepPurpleAccent),
    ));
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      buildHorizontalOptionButton(title: 'For Consumption', hasCaret: true, hasStartingValue: true, f: tapConsumptionVsReferenceToggle),
                      SizedBox(width: 10),
                      buildHorizontalOptionButton(title: 'Newest to Oldest', hasCaret: true, hasStartingValue: true, f: tapDateTimeSortToggle),
                      SizedBox (width: 10),
                      buildHorizontalOptionButton(title: 'Tag', hasCaret: true, hasStartingValue: false, f: tapTagSelector),
                      SizedBox (width: 10),
                      buildHorizontalOptionButton(title: 'Topic', hasCaret: true, hasStartingValue: false, f: tapTopicSelector),
                      SizedBox (width: 10),
                      buildHorizontalOptionButton(title: 'Media Type', hasCaret: true, hasStartingValue: false, f: tapMediaTypeSelector),
                      SizedBox (width: 10),
                      buildHorizontalOptionButton(title: 'Favorite', hasCaret: false, hasStartingValue: false, icon: Icons.star, f: tapFavoritedToggle),
                      SizedBox (width: 10),
                      buildHorizontalOptionButton(title: 'Archived', hasCaret: false, hasStartingValue: false, icon: Icons.check, f: tapArchivedToggle)
                    ],
                  )
                ),
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
