import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/screens/save/tag_selector.dart';
import 'package:interestopia/shared/tag_selector_manager.dart';
import 'package:interestopia/models/topic_ui_model.dart';
import 'package:interestopia/shared/topic_selector_manager.dart';
import 'package:interestopia/models/topic_with_index_bundle.dart';
import 'package:interestopia/models/tag_ui_model.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';

class TempSavePage extends StatefulWidget {

  const TempSavePage({ this.destination }); // I removed the key portion of this line to solve that duplicate global key issue

  final Destination destination;

  @override
  _TempSavePageState createState() => _TempSavePageState();
}


class _TempSavePageState extends State<TempSavePage> {

  User user;

  String title = '';
  String url = '';
  TopicSelectorManager tManager = TopicSelectorManager();
  bool isConsumptionToggleOn = true;
  bool isReferenceToggleOn = false;

  //String newTagName = ''; // TODO - this is only temporary (although I may end up making use of it. We will have to see.)

  //TagSelectorManager tagSelectorManager = TagSelectorManager();
  List<dynamic> selectedTagIds = [];

  List<String> tempList = [
    'first tag',
    'second tag',
    'second tag'
  ];

  Future<List<TopicWithIndexBundle>> _getTopicBundles(String text) async {

    return tManager.findTopicsWithStr(text);
  }

  Future<List<String>> _getAllItems(String text) async {

    List<String> items = [
      'topic'
    ];

    return items;
  }

  List<MaterialButton> _getListOfTopicButtons() {
    List<MaterialButton> buttonList = [];

    for (int i = 0; i < tManager.getTopics().length; i++) {
      buttonList.add(buildTopicButton(index: i, topic: tManager.getTopic(i)));
    }

    return buttonList;
  }

  MaterialButton buildTopicButton({int index, Topic_UI_Model topic}) {
    return MaterialButton(
      onPressed: () {
        print(topic.title + ' pressed');

        // only do this if the selected topic isn't on
        if (topic.isOn) {
          setState(() {
            tManager.resetSelection();
          });
        } else {
          print('else condition');
          setState(() {
            tManager.selectTopic(index);
          });
        }
      },
      color: topic.isOn ? Colors.deepPurpleAccent : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: topic.isOn ? Colors.transparent : Colors.deepPurpleAccent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
              topic.icon,
              color: topic.isOn ? Colors.white : Colors.deepPurpleAccent
          ),
          Text(
              topic.title,
              style: TextStyle(
                color: topic.isOn ? Colors.white : Colors.deepPurpleAccent
              ),
          )
        ],
      )
    );
  }

  MaterialButton buildButtonWithLeadingIcon({IconData icon, String title, bool isOn}) {
    return MaterialButton(
      onPressed: () {
        if (!isOn) {
          if (title == 'Consumption') {
            //print('turn consumption on and reference off');
            setState(() {
              this.isConsumptionToggleOn = true;
              this.isReferenceToggleOn = false;
            });
          } else {
            //print('turn reference on and reference off');
            setState(() {
              this.isConsumptionToggleOn = false;
              this.isReferenceToggleOn = true;
            });
          }
        }
      },
      color: isOn ? Colors.deepPurpleAccent : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isOn ? Colors.transparent : Colors.deepPurpleAccent),
      ),
      child:
        Row(
          children: <Widget>[
            Icon(
                icon,
                color: isOn ? Colors.white : Colors.deepPurpleAccent
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: isOn ? Colors.white: Colors.deepPurpleAccent
              )
            )
          ],
        )
    );
  }

  bool isSaveButtonActive() {
    return title != '' && url != '' && tManager.isATopicSelected();
  }

  void saveItem({ User user }) {
    DatabaseService(uid: user.uid).postNewSavedItem(
        title: title,
        url: url,
        dateTimeSaved: DateTime.now(),
        description: '',
        topic: tManager.getNameOfSelectedTopic(),
        consumptionOrReference: isConsumptionToggleOn ? 'consumption' : 'reference',
        associatedTagIds: selectedTagIds
    );
  }

  void _updateSelectedTagList(tagIdList) {
    print('TempSavePage - _updateSelectedTagList');
    print('Length of selected tag list: ' + tagIdList.length.toString());
    setState(() {
      selectedTagIds = tagIdList;
    });
  }

  @override
  Widget build(BuildContext context) {

    // accesses the user data from the provider
    final user = Provider.of<User>(context);

    return StreamProvider<List<Tag>>.value(
      value: DatabaseService(uid: user.uid).tags,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('Saving to Interestopia'),
          actions: <Widget>[
            MaterialButton(
              onPressed: isSaveButtonActive() ? () => saveItem(user: user) : null,
              child: Text(
                  'Save',
                  style: TextStyle(
                    color: isSaveButtonActive() ? Colors.white : Colors.grey[400],
                    fontSize: 18
                  ),
              )
            )
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: 2000, // Let's use this for now, especially since this is inside of a CustomScrollView
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              onChanged: (val) {
                                setState(() => title = val);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Title',
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              onChanged: (val) {
                                setState(() => url = val);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Url',
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: Text(
                              'Select a topic',
                              style: TextStyle(
                                fontSize: 18
                              )
                          ),
                        ),
                        Expanded(
                          child: SearchBar<TopicWithIndexBundle>(
                            minimumChars: 1,
                            icon: null,
                            onSearch: _getTopicBundles,
                            onItemFound: (TopicWithIndexBundle item, int index) {
                              return buildTopicButton(index: item.index, topic: item.topic);
                            },
                            hintText: 'Enter topic name',
                            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
                            headerPadding: EdgeInsets.symmetric(horizontal: 10),
                            listPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            placeHolder: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GridView.count(
                                primary: false, // removes scrolling from this gridview
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 3,
                                children: _getListOfTopicButtons()
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Text(
                                        'For Consumption or For Reference?',
                                        style: TextStyle(
                                          fontSize: 18
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            child: buildButtonWithLeadingIcon(icon: Icons.restaurant_menu, title: 'Consumption', isOn: this.isConsumptionToggleOn)
                                        ),
                                        SizedBox(
                                          width: 10
                                        ),
                                        Expanded(
                                            child: buildButtonWithLeadingIcon(icon: Icons.book, title: 'Reference', isOn: this.isReferenceToggleOn)
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Text(
                                        '(Optional) Add tag(s)',
                                        style: TextStyle(
                                          fontSize: 18
                                        )
                                    ),
                                  ),
                                  /*
                                  Expanded(
                                    flex: 1,
                                    child: SearchBar(
                                      icon: null,
                                      onSearch: _getAllItems,
                                      onItemFound: (String item, int index) {
                                        return Text(item);
                                      },
                                      hintText: 'Enter name of tags',
                                      searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
                                      headerPadding: EdgeInsets.symmetric(horizontal: 10),
                                      listPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      placeHolder: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ListView.separated(
                                            itemBuilder: (BuildContext context, int index) {
                                              return Text(tempList[index]);
                                            },
                                            separatorBuilder: (BuildContext context, int index) => Divider(),
                                            itemCount: tempList.length),
                                      ),
                                    ),
                                  )
                                   */
                                  Expanded(
                                    flex: 1,
                                    child: TagSelector(
                                      destination: widget.destination,
                                      parentAction: _updateSelectedTagList,
                                    )
                                  ),
                                ],
                            )
                        ),

                      ],
                )
              ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
