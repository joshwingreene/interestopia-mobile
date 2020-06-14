import 'package:flutter/material.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:interestopia/models/search_config.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/shared/measure_size.dart';
import 'package:provider/provider.dart';

class SearchBarArea extends StatefulWidget {

  SearchBarArea({ this.currentSearchConfig });

  SearchConfig currentSearchConfig;

  @override
  _SearchBarAreaState createState() => _SearchBarAreaState();
}

class _SearchBarAreaState extends State<SearchBarArea> {

  int mode = 0;

  double itemInfoAreaWidth;

  Map<String, Tag> tagMap = Map<String, Tag>();

  Future<List<SavedItem>> _getAllItems(String text) async {

    List<SavedItem> items = [
      SavedItem(title: 'one', dateTimeSaved: DateTime.now(), description: '', topic: 'design'),
      SavedItem(title: 'two', dateTimeSaved: DateTime.now(), description: '', topic: 'education'),
      SavedItem(title: 'three', dateTimeSaved: DateTime.now(), description: '', topic: 'technology')
    ];

    return items;
  }

  List<Widget> buildTimeEstimate({ int timeEstimate }) {
    return [
      Icon(
        Icons.access_time,
        color: Colors.deepPurpleAccent,
        size: 20,
      ),
      SizedBox(width: 5),
      Text(
          timeEstimate.toString() + 'm',
          style: TextStyle(
            color: Colors.grey[700],
          )
      ),
    ];
  }

  List<Widget> buildTagDisplay({ double remainingSpace, List<dynamic> tagIdList }) {

    List<Widget> result = [];

    double fontSize = 9.0;
    double iconSize = 20.0;
    double totalTagTextWidth = iconSize + 5;
    List<double> tagWidthList = [totalTagTextWidth]; // start with the width of the icon and that sized box
    List<String> tagStringList = ['icon'];

    for (int i = 0; i < tagIdList.length; i++) {
      String tempTagTitle = tagMap[tagIdList[i]].title;
      double tempTagWidth = tempTagTitle.length * fontSize;
      totalTagTextWidth += tempTagWidth;
      tagWidthList.add(tempTagWidth);
      tagStringList.add(tempTagTitle);
    }

    bool willTheTagsOverflow = totalTagTextWidth > remainingSpace;

    // determine tags to display for row
    double rowWidth = iconSize + 5;
    List<Widget> row = [];
    String tagsStr = "";

    if (!willTheTagsOverflow) {
      for (int j = 1; j < tagWidthList.length; j++) {
        //print('looking at tag: ' + tagStringList[j] + ' has width: ' + tagWidthList[j].toString());
        //print('firstRowWidth: ' + rowWidth.toString());
        if ((rowWidth + tagWidthList[j]) >= remainingSpace) {
          continue;
        } else {
          if (tagsStr.length == 0) {
            tagsStr += tagStringList[j];
          } else {
            tagsStr += ', ' + tagStringList[j];
          }
          rowWidth += tagWidthList[j];
        }
      }
    } else {
      List<int> leftOverTagIndexes = [];
      rowWidth += 5 * fontSize; // for the ', etc' at the end

      for (int j = 1; j < tagWidthList.length; j++) {
        //print('looking at tag: ' + tagStringList[j] + ' has width: ' + tagWidthList[j].toString());
        //print('firstRowWidth: ' + rowWidth.toString());
        if ((rowWidth + tagWidthList[j]) >= remainingSpace) {
          leftOverTagIndexes.add(j);
          continue;
        } else {
          if (tagsStr.length == 0) {
            tagsStr += tagStringList[j];
          } else {
            tagsStr += ', ' + tagStringList[j];
          }
          rowWidth += tagWidthList[j];
        }
      }
      tagsStr += ', etc';
    }

    result.add(Icon(Icons.label_outline, color: Colors.deepPurpleAccent, size: iconSize));
    result.add(SizedBox(width: 5));
    result.add(Text(tagsStr, style: TextStyle(color: Colors.grey[700])));

    return result;
  }

  Row buildRow({ double itemInfoAreaWidth, int timeEstimate, List<dynamic> tagIdList }) { // assigning this to the children property of a new column

    bool hasTags = tagIdList.length != 0;
    bool hasTimeEstimate = timeEstimate != null;

    double fontSize = 10.0;
    double iconSize = 20.0;

    if (!hasTags) {
      return Row(children: buildTimeEstimate(timeEstimate: timeEstimate));
    } else if (!hasTimeEstimate) {
      // ignore the size of the time estimate components when putting the tag display together
      return Row(children: buildTagDisplay(remainingSpace: itemInfoAreaWidth, tagIdList: tagIdList));
    } else {
      double calcRemainingSpace = itemInfoAreaWidth - (iconSize + 5 + (4 * fontSize) + 10); // subtracting the space taken by the time estimate stuff and the sized box after it
      List<Widget> widgetList = buildTimeEstimate(timeEstimate: timeEstimate);
      widgetList.add(SizedBox(width: 10));
      widgetList.addAll(buildTagDisplay(tagIdList: tagIdList, remainingSpace: calcRemainingSpace));
      return Row(children: widgetList);
    }
  }

  MaterialButton buildClickableListItem(item) {

    print('Item Title: ' + item.title);
    //print('itemInfoAreaWidth: ' + itemInfoAreaWidth.toString());

    //print(item.associatedTagIds.toString());

    return MaterialButton(
      onPressed: () => print('Item Pressed'),
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset('images/temp.png')
              ),
            ),
          ),
          MeasureSize(
            onChange: (size) {
              setState(() {
                print('size: ' + size.width.toString());
                itemInfoAreaWidth = size.width;
              });
            },
            child: Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                        //fontSize: 14
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        'medium.com',
                        style: TextStyle(
                            color: Colors.grey[500]
                        )
                    ),
                    SizedBox(height: 10),
                    item.parsedWordCount == null && item.associatedTagIds.length == 0 ? SizedBox(height: 0) : buildRow(itemInfoAreaWidth: itemInfoAreaWidth, timeEstimate: 100, tagIdList: item.associatedTagIds)
                    // TODO: Convert the parsed word count to the average listening or reading time
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<SavedItem> changeResult({ List<SavedItem> savedItems }) {

    //print('changeResult - mode - ' + widget.currentSearchConfig.getConfRefAllMode().toString());

    List<SavedItem> result;

    if (widget.currentSearchConfig.getConfRefAllMode() == SearchConfig.CONSUMPTION) {
      result = savedItems.where((item) => item.consumptionOrReference == 'consumption').toList();
    } else if (widget.currentSearchConfig.getConfRefAllMode() == SearchConfig.REFERENCE) {
      result = savedItems.where((item) => item.consumptionOrReference == 'reference').toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var tempSavedItems = Provider.of<List<SavedItem>>(context);
    if (tempSavedItems != null) // This should fix that 'where' called on null value issue when the app is initially run
      tempSavedItems = changeResult(savedItems: tempSavedItems);
    final tempTags = Provider.of<List<Tag>>(context);
    final SearchBarController _searchBarController = SearchBarController();

    if (tempTags != null) {
      for (int i = 0; i < tempTags.length; i++) {
        print('tag id: ' + tempTags[i].id);
        tagMap[tempTags[i].id] = tempTags[i];
      }
    }

    /*
    tempSavedItems.forEach((item) { // I'm going to assume that Firestore won't read from the backend unnecessary, ex. when the state of one of the horizontal list toggles
      print(item.title);
    });
     */

    return SearchBar( // What's being done with the placeholder property is just being done temporarily. This will fetch a specific number of the most recently saved items. If the user scrolls, it will fetch more.
      searchBarController: _searchBarController,
      placeHolder: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return buildClickableListItem(tempSavedItems[index]);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(indent: 8.0, endIndent: 8.0, color: Colors.grey[400]),
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
