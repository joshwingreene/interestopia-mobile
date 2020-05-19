import 'package:flutter/material.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:provider/provider.dart';

class SearchBarArea extends StatefulWidget {
  @override
  _SearchBarAreaState createState() => _SearchBarAreaState();
}

class _SearchBarAreaState extends State<SearchBarArea> {

  Future<List<SavedItem>> _getAllItems(String text) async {

    List<SavedItem> items = [
      SavedItem(title: 'one', dateTimeSaved: DateTime.now(), description: '', topic: 'design'),
      SavedItem(title: 'two', dateTimeSaved: DateTime.now(), description: '', topic: 'education'),
      SavedItem(title: 'three', dateTimeSaved: DateTime.now(), description: '', topic: 'technology')
    ];

    return items;
  }

  FlatButton buildClickableListItem(item) {
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
                      item.title,
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
    final tempSavedItems = Provider.of<List<SavedItem>>(context);

    /*
    tempSavedItems.forEach((item) { // I'm going to assume that Firestore won't read from the backend unnecessary, ex. when the state of one of the horizontal list toggles
      print(item.title);
    });
     */

    return SearchBar( // What's being done with the placeholder property is just being done temporarily. This will fetch a specific number of the most recently saved items. If the user scrolls, it will fetch more.
      placeHolder: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return buildClickableListItem(tempSavedItems[index]);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: tempSavedItems != null ? tempSavedItems.length : 0),
      hintText: 'Enter title or phrase',
      searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
      headerPadding: EdgeInsets.symmetric(horizontal: 10),
      listPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      icon: Icon(Icons.search),
      onSearch: _getAllItems,
      onItemFound: (SavedItem item, int index) {
        return buildClickableListItem(item);
      },
    );
  }
}
