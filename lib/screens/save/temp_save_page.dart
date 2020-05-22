import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';

class TempSavePage extends StatefulWidget {

  const TempSavePage({ this.destination }); // I removed the key portion of this line to solve that duplicate global key issue

  final Destination destination;

  @override
  _TempSavePageState createState() => _TempSavePageState();
}

class _TempSavePageState extends State<TempSavePage> {

  List<String> tempList = [
    'first tag',
    'second tag',
    'second tag'
  ];

  Future<List<String>> _getAllItems(String text) async {

    List<String> items = [
      'topic'
    ];

    return items;
  }

  MaterialButton buildTopicButton({IconData icon, String title, bool isOn}) {
    return MaterialButton(
      onPressed: () => print(title + ' pressed'),
      color: isOn ? Colors.deepPurpleAccent : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isOn ? Colors.transparent : Colors.deepPurpleAccent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
              icon,
              color: isOn ? Colors.white : Colors.deepPurpleAccent
          ),
          Text(
              title,
              style: TextStyle(
                color: isOn ? Colors.white : Colors.deepPurpleAccent
              ),
          )
        ],
      )
    );
  }

  MaterialButton buildButtonWithLeadingIcon({IconData icon, String title, bool isOn}) {
    return MaterialButton(
      onPressed: () => print(title + ' pressed'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Saving to Interestopia'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => print('Save button'),
            child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
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
                height: 1900, // Let's use this for now, especially since this is inside of a CustomScrollView
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
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
                        child: SearchBar(
                          icon: null,
                          onSearch: _getAllItems,
                          onItemFound: (String item, int index) {
                            return Text(item);
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
                              children: <Widget>[
                                buildTopicButton(icon: Icons.brush, title: 'Arts', isOn: false),
                                buildTopicButton(icon: Icons.business, title: 'Business', isOn: false),
                                buildTopicButton(icon: Icons.create, title: 'Design', isOn: false),
                                buildTopicButton(icon: Icons.school, title: 'Education', isOn: false),
                                buildTopicButton(icon: Icons.shopping_basket, title: 'Fashion', isOn: false),
                                buildTopicButton(icon: Icons.monetization_on, title: 'Finance', isOn: false),
                                buildTopicButton(icon: Icons.fastfood, title: 'Food', isOn: false),
                                buildTopicButton(icon: Icons.hourglass_empty, title: 'Govt', isOn: false),
                                buildTopicButton(icon: Icons.healing, title: 'Health', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'Leisure', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'News', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'Religion', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'Science', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'Self', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'Society', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'Sports', isOn: false),
                                buildTopicButton(icon: Icons.brush, title: 'Tech', isOn: false),
                              ],
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
                                          child: buildButtonWithLeadingIcon(icon: Icons.restaurant_menu, title: 'Consumption', isOn: true)
                                      ),
                                      SizedBox(
                                        width: 10
                                      ),
                                      Expanded(
                                          child: buildButtonWithLeadingIcon(icon: Icons.book, title: 'Reference', isOn: false)
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  child: Text(
                                      '(Optional) Add tag(s)',
                                      style: TextStyle(
                                        fontSize: 18
                                      )
                                  ),
                                ),
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
    );
  }
}
