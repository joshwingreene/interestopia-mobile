import 'package:flutter/material.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/screens/search/label.dart';
import 'package:interestopia/shared/measure_size.dart';
import 'package:provider/provider.dart';

class SearchBarArea extends StatefulWidget {
  @override
  _SearchBarAreaState createState() => _SearchBarAreaState();
}

class _SearchBarAreaState extends State<SearchBarArea> {

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

  List<Label> _getListOfLabels(List<dynamic> tagIdList) {
    List<Label> labelList = [];

    for (int i = 0; i < tagIdList.length; i++) {
      labelList.add(Label(text: tagMap[tagIdList[i]].title));
    }

    return labelList;
  }

  Column getTagDisplay({ double itemInfoAreaWidth, String placeholder, List<dynamic> tagIdList }) { // assigning this to the children property of a new column

    Column colResult;
    double fontSize = 8.0;
    double totalTagTextWidth = placeholder.length * fontSize + 16.0; // 14 is a default font size // 16 is the total horizontal padding that is added by the label
    List<double> tagWidthList = [totalTagTextWidth]; // starting with the resulting placeholder width
    List<String> tagStringList = [placeholder];

    for (int i = 0; i < tagIdList.length; i++) {
      String tempTagTitle = tagMap[tagIdList[i]].title;
      double tempTagWidth = tempTagTitle.length * fontSize + 16.0 + 8.0; // 8.0 is for the left margin
      tagWidthList.add(tempTagWidth);
      totalTagTextWidth += tempTagWidth;
      tagStringList.add(tempTagTitle);
    }

    //print('itemInfoAreaWidth: ' + itemInfoAreaWidth.toString());

    //print('totalTagTextWidth: ' + totalTagTextWidth.toString());

    double numberOfRows = totalTagTextWidth / itemInfoAreaWidth;
    //print('itemInfoAreaWidth / totalTagTextWidth = ' + numberOfRows.toString());

    if (numberOfRows < 1) {

      List<Label> row = [Label.isEstimateLabel(text: placeholder)];

      for (int i = 1; i < tagStringList.length; i++) {
        row.add(Label(text: tagStringList[i]));
      }

      colResult = Column(children: [ Row(children: row) ]);

    } else if (numberOfRows >= 1 && numberOfRows < 2) { // at most 2 rows (will be adding a condition before this for at most 1 row)

      // determine tags to display for first row
      double firstRowWidth = placeholder.length * fontSize + 16.0;
      List<Label> firstRow = [Label.isEstimateLabel(text: placeholder)];
      List<Label> secondRow = []; // for left over tags

      for (int j = 1; j < tagWidthList.length; j++) {
        //print('looking at tag: ' + tagStringList[j] + ' has width: ' + tagWidthList[j].toString());
        //print('firstRowWidth: ' + firstRowWidth.toString());
        if ((firstRowWidth + tagWidthList[j]) >= itemInfoAreaWidth) {
          if (secondRow.length == 0) {
            secondRow.add(Label.noLeftMargin(text: tagStringList[j]));
          } else {
            secondRow.add(Label(text: tagStringList[j]));
          }
          continue;
        } else {
          firstRow.add(Label(text: tagStringList[j]));
          firstRowWidth += tagWidthList[j];
        }
      }

      // put the col together using each row
      colResult = Column(children: [ Row(children: firstRow), SizedBox(height: 10), Row(children: secondRow) ]);

    } else if (numberOfRows >= 2) { // 2 rows or more with "..." tag at the end of the second row

      // determine tags to display for first row (copied from above with slight changes)
      double firstRowWidth = placeholder.length * fontSize + 16.0;
      List<Label> firstRow = [Label.isEstimateLabel(text: placeholder)];
      List<int> leftOverTagIndexes = [];

      for (int j = 1; j < tagWidthList.length; j++) {
        if ((firstRowWidth + tagWidthList[j]) >= itemInfoAreaWidth) {
          leftOverTagIndexes.add(j);
          continue;
        } else {
          firstRow.add(Label(text: tagStringList[j]));
          firstRowWidth += tagWidthList[j];
        }
      }

      // determine tags to display for the second row
      double secondRowWidth = 3 * fontSize + 16.0 + 8.0; // this is for the "..." // 8.0 is for the left margin
      List<Label> secondRow = [];

      for (int m = 0; m < leftOverTagIndexes.length; m++) {
        //print('looking at tag: ' + tagStringList[leftOverTagIndexes[m]] + ' has width: ' + tagWidthList[leftOverTagIndexes[m]].toString());
        //print('secondRowWidth: ' + secondRowWidth.toString());
        if ((secondRowWidth + tagWidthList[leftOverTagIndexes[m]]) >= itemInfoAreaWidth) {
          continue;
        } else {
          if (secondRow.length == 0) {
            secondRow.add(Label.noLeftMargin(text: tagStringList[leftOverTagIndexes[m]]));
          } else {
            secondRow.add(Label(text: tagStringList[leftOverTagIndexes[m]]));
          }
          secondRowWidth += tagWidthList[leftOverTagIndexes[m]];
        }
      }

      // add the "..." label
      secondRow.add(Label(text: '...'));

      // put the col together using each row
      colResult = Column(children: [ Row(children: firstRow), SizedBox(height: 10), Row(children: secondRow) ]);
    }

    return colResult;
  }

  MaterialButton buildClickableListItem(item) {

    //print('Item Title: ' + item.title);

    //print(item.associatedTagIds.toString());

    return MaterialButton(
      onPressed: () => print('Item Pressed'),
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                        fontWeight: FontWeight.normal
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
                    itemInfoAreaWidth != null ? getTagDisplay(itemInfoAreaWidth: itemInfoAreaWidth, placeholder: '100 mins', tagIdList: item.associatedTagIds) : Column(children: [])
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Image.asset('images/temp.png'),
            ),
          ),
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
