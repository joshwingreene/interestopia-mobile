import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:interestopia/shared/functions.dart';

class TagSelector extends StatefulWidget {

  TagSelector({ Key key, this.destination, this.parentAction }) : super(key: key);

  final Destination destination;

  void Function(List<dynamic> value) parentAction; // I couldn't use a named parameter for some reason.

  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {

  String newTagName = ''; // TODO - this is only temporary (although I may end up making use of it. We will have to see.)

  List<Tag> receivedTags;

  bool willHaveDuplicateTag = false;

  Map<String, bool> selectionState = Map<String, bool>();

  MaterialButton buildTagListItem({int index, String id, String title, int numOfItems, bool isSelected}) {
    return MaterialButton(
        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        onPressed: () {
          setState(() {
            selectionState[id] = !selectionState[id];
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
                      onPressed: () => Navigator.pushNamed(context, '/edit_tag', arguments: { 'tag': receivedTags[index], 'all_tags': receivedTags }),
                      height: 20,
                      minWidth: 20,
                      child: Icon(
                          Icons.edit,
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
      if (selectionState[tempTag.id]) {
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
        print('tag id: ' + receivedTags[i].id + ' tag title: ' + receivedTags[i].title);
        if (selectionState[receivedTags[i].id] == null) {
          selectionState[receivedTags[i].id] = false;
        }
      }
    }

    //print('willHaveDuplicateTag: ' + willHaveDuplicateTag.toString());

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (val) {
              setState(() {
                newTagName = val;
                if (tagWithTitleExists(title: val, tags: receivedTags)) {
                  willHaveDuplicateTag = true;
                } else {
                  willHaveDuplicateTag = false;
                }
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter tag',
            ),
            onSubmitted: (text) {
              if (!willHaveDuplicateTag) {
                setState(() {
                  // Generate the id for this tag
                  String newTagId = DateTime.now().toString();

                  // Should be selected by default
                  selectionState[newTagId] = true;

                  // Get the currently selected tag ids and Add this tag's id to it
                  List<dynamic> tempListOfSelectedIds = getListOfSelectedTagIds();
                  tempListOfSelectedIds.add(newTagId);

                  // Notify the parent with the result
                  widget.parentAction(tempListOfSelectedIds);

                  // Save to backend
                  DatabaseService(uid: user.uid).postNewTag(id: newTagId, title: text);

                  willHaveDuplicateTag = true; // This is needed for the current textfield approach.
                });
              }
            },
          ),
        ),
        willHaveDuplicateTag ? Text('Duplicate tags aren\'t allowed', style: TextStyle(color: Colors.red)) : SizedBox(height: 0),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    Tag tempTag = receivedTags[index];
                    return buildTagListItem(index: index, id: tempTag.id, title: tempTag.title, numOfItems: tempTag.getNumberOfItems(), isSelected: selectionState[tempTag.id]);
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemCount: receivedTags != null ? receivedTags.length : 0),
            )
        )
      ],
    );
  }
}