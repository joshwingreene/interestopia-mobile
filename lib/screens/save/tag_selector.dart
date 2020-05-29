import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/tag_ui_model.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/screens/save/temp_save_page.dart';
import 'package:interestopia/services/database.dart';
import 'package:interestopia/shared/tag_selector_manager.dart';
import 'package:provider/provider.dart';

class TagSelector extends StatefulWidget {

  TagSelector({ Key key, this.parentAction }) : super(key: key);

  //final TempSavePage prevPageContext;
  void Function(List<String> value) parentAction; // I couldn't use a named parameter for some reason.

  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {

  String newTagName = ''; // TODO - this is only temporary (although I may end up making use of it. We will have to see.)

  //TagSelectorManager tagSelectorManager = TagSelectorManager(); // TODO: I'm thinking of passing in the tags from the provider if I can do this
  TagSelectorManager tagSelectorManager;

  List<int> newTagIndexes = [];

  List<Tag> receivedTags;

  //List<Tag> receivedTags;

  /*
  @override
  void initState() {
    //print('Search - initState');
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { // Needed in order to do the included code only after super.initState has been completed
      // accesses the tag data from the provider
      receivedTags = Provider.of<List<Tag>>(context);
    });
  }

   */

  MaterialButton buildTagListItem({int index, String title, int numOfItems, bool isSelected}) {
    return MaterialButton(
        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        onPressed: () {
          setState(() {
            if (!isSelected) {
              for (int i = 0; i < newTagIndexes.length; i++) {
                if (newTagIndexes[i] == index) {
                  print('new tag doesn\'t have an id');
                  for (int j = 0; j < receivedTags.length; j++) {
                    print('comparing ' + title + ' with ' + receivedTags[j].title);
                    if (receivedTags[j].title == title) { // this isn't being run, which is why the ids aren't being added to the tags
                      print('id of associated received tag: ' + receivedTags[j].id);
                      print('adding id to tag using index #' + index.toString() + ' and id ' + receivedTags[j].id);
                      tagSelectorManager.addIdToTag(index: index, id: receivedTags[j].id);
                    }
                    break;
                  }
                  break;
                }
              }
            }
            tagSelectorManager.selectTag(index: index);
            List<dynamic> selectedTagIds = tagSelectorManager.getSelectedTagIds();
            for (int k = 0; k < selectedTagIds.length; k++) {
              print('selected id: ' + selectedTagIds[k].toString());
            }
            widget.parentAction(selectedTagIds);
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

  @override
  Widget build(BuildContext context) {

    // accesses the user data from the provider
    final user = Provider.of<User>(context);

    receivedTags = Provider.of<List<Tag>>(context);
    for (int i = 0; i < receivedTags.length; i++) {
      print(receivedTags[i].title);
    }
    if (receivedTags != null) {
      if (tagSelectorManager == null) {
        tagSelectorManager = TagSelectorManager(tags: receivedTags);
      } else {
        print('build - else');
        //tagSelectorManager.updateTags(tags: receivedTags); // remember, we would have to use setState (but I can't do that here)
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
            onSubmitted: (text) { // TODO: I need to make sure that
              setState(() {
                newTagIndexes.add(tagSelectorManager.getNumberOfTags());
                tagSelectorManager.addTag(tag: Tag_UI_Model(title: text));
                DatabaseService(uid: user.uid).postNewTag(title: text); // TODO: I want to be able to have new tags automatically be selected (leaving for later)
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
                    Tag_UI_Model tempTag = tagSelectorManager.getTag(index: index);
                    return buildTagListItem(index: index, title: tempTag.title, numOfItems: 0, isSelected: tempTag.isSelected);
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemCount: tagSelectorManager != null ? tagSelectorManager.getNumberOfTags() : 0),

              /*
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    Tag_UI_Model tempTag = tagSelectorManager.getTag(index: index);
                    return buildTagListItem(index: index, title: (tempTag.title), numOfItems: tempTag.getNumberOfItems(), isSelected: tempTag.isSelected);
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemCount: tagSelectorManager.getNumberOfTags()),

               */
            )
        )
      ],
    );
  }
}