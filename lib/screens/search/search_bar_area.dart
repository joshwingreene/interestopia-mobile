import 'package:flutter/material.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/screens/search/label.dart';
import 'package:provider/provider.dart';

class SearchBarArea extends StatefulWidget {
  @override
  _SearchBarAreaState createState() => _SearchBarAreaState();
}

class _SearchBarAreaState extends State<SearchBarArea> {

  Map<String, Tag> tagMap = Map<String, Tag>();

  Future<List<SavedItem>> _getAllItems(String text) async {

    List<SavedItem> items = [
      SavedItem(title: 'one', dateTimeSaved: DateTime.now(), description: '', topic: 'design'),
      SavedItem(title: 'two', dateTimeSaved: DateTime.now(), description: '', topic: 'education'),
      SavedItem(title: 'three', dateTimeSaved: DateTime.now(), description: '', topic: 'technology')
    ];

    return items;
  }

  List<Label> _getListOfLabels(List<dynamic> tagIdList) {
    List<Label> labelList = [];

    for (int i = 0; i < tagIdList.length; i++) {
      labelList.add(Label(text: tagMap[tagIdList[i]].title));
    }

    return labelList;
  }

  FlatButton buildClickableListItem(item) {

    // TODO: Get the tags via the ids (I believe I wanted to retrieve all of the tags first and then getting the tag names via their ids.)

    print(item.associatedTagIds.toString());

    // get the

    //List<String> tagTitles = item.associatedTagIds.

    return FlatButton(
      onPressed: () => print('Item Pressed'),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                  ),
                  SizedBox(height: 10),
                  Text(
                      'medium.com',
                      style: TextStyle(
                          color: Colors.grey[500]
                      )
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: GridView.count(
                        primary: false, // removes scrolling from this gridview
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 3,
                        children: [ Label(text: 'one'), Label(text: 'two'), Label(text: 'three'), Label(text: 'four'), Label(text: 'five'), Label(text: 'six') ]//_getListOfLabels(item.associatedTagIds)
                    ),
                  ),
                  /*
                  item.associatedTagIds.length != 0 ? Label(
                    text: 'has tags',
                  ) : SizedBox(height: 10) */
                ],
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
    final tempTags = Provider.of<List<Tag>>(context);

    if (tempTags != null) {
      for (int i = 0; i < tempTags.length; i++) {
        tagMap[tempTags[i].id] = tempTags[i];
      }
    }

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
