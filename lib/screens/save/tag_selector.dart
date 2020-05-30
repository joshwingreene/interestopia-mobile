import 'package:flutter/material.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';

class TagSelector extends StatefulWidget {

  TagSelector({ Key key, this.parentAction }) : super(key: key);

  void Function(List<dynamic> value) parentAction; // I couldn't use a named parameter for some reason.

  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {

  String newTagName = ''; // TODO - this is only temporary (although I may end up making use of it. We will have to see.)

  List<Tag> receivedTags;

  Map<String, bool> selectionState = Map<String, bool>();

  MaterialButton buildTagListItem({int index, String title, int numOfItems, bool isSelected}) {
    return MaterialButton(
        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        onPressed: () {
          setState(() {
            selectionState[title] = !selectionState[title];
            widget.parentAction(getListOfSelectedTagIds());
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                    color: isSelected ? Colors.deepPurpleAccent : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: isSelected ? 25 : 14
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      numOfItems.toString()
                  ),
                  SizedBox(
                      width: 10
                  ),
                  MaterialButton(
                      onPressed: () => print('Delete button tapped'),
                      height: 20,
                      minWidth: 20,
                      child: Icon(
                          Icons.delete,
                          color: Colors.grey
                      )
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  List<dynamic> getListOfSelectedTagIds() {
    List<dynamic> result = [];

    for (int i = 0; i < receivedTags.length; i++) {
      Tag tempTag = receivedTags[i];
      if (selectionState[tempTag.title]) {
        result.add(tempTag.id);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {

    print('build');

    // accesses the user data from the provider
    final user = Provider.of<User>(context);

    receivedTags = Provider.of<List<Tag>>(context);

    if (receivedTags != null) {
      for (int i = 0; i < receivedTags.length; i++) {
        print(receivedTags[i].title);
        if (selectionState[receivedTags[i].title] == null) {
          selectionState[receivedTags[i].title] = false;
        }
      }
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (val) {
              setState(() => newTagName = val);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter tag',
            ),
            onSubmitted: (text) { // TODO: I need to make sure that this can't be submitted with an empty string
              setState(() {
                // Should be selected by default
                selectionState[text] = true;

                // Get the currently selected tag ids and Add this tag's id to it (which is its title)
                List<dynamic> tempListOfSelectedIds = getListOfSelectedTagIds();
                tempListOfSelectedIds.add(text);

                // Notify the parent with the result
                widget.parentAction(tempListOfSelectedIds);

                // Save to backend
                DatabaseService(uid: user.uid).postNewTag(title: text);
              });
            },
          ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    Tag tempTag = receivedTags[index];
                    return buildTagListItem(index: index, title: tempTag.title, numOfItems: tempTag.getNumberOfItems(), isSelected: selectionState[tempTag.title]);
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemCount: receivedTags != null ? receivedTags.length : 0),
            )
        )
      ],
    );
  }
}