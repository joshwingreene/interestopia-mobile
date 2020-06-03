import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:interestopia/shared/functions.dart';

class EditTag extends StatefulWidget {

  const EditTag({ this.destination });

  final Destination destination;

  @override
  _EditTagState createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {

  TextEditingController controller;

  Map data = {};

  String tagName;

  bool willHaveDuplicateTag = false;

  bool isConfirmButtonActive() {
    if (tagName != null) {
      return data['tag'].title != tagName && !willHaveDuplicateTag;
    } else {
      return false;
    }
  }

  void renameTag({ String userId }) {

    DatabaseService(uid: userId).modifyTag(id: data['tag'].id, title: tagName, associatedItemIds: data['tag'].associatedItemIds)
        .then((value) {
          // Go back to the TempSavePage
          Navigator.pop(context);
    });
  }

  void deleteTag({ String userId }) {

    DatabaseService(uid: userId).deleteTag(id: data['tag'].id, associatedItemIds: data['tag'].associatedItemIds)
        .then((value) {
          // Go back to the TempSavePage
          Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    // accesses the user data from the provider
    final user = Provider.of<User>(context);

    data = ModalRoute.of(context).settings.arguments;

    if (tagName == null) {
      controller = TextEditingController(text: data['tag'].title);
    }

    //print('willHaveDuplicateTag: ' + willHaveDuplicateTag.toString());

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
            'Edit Tag',
            style: TextStyle(
              color: Colors.black,
            ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Theme.of(context).brightness,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          MaterialButton(
              onPressed: isConfirmButtonActive() ? () => renameTag(userId: user.uid) : null,
              child: Text(
                'Confirm',
                style: TextStyle(
                    color: isConfirmButtonActive() ? Colors.black : Colors.grey[400],
                    fontSize: 18
                ),
              )
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0.0),
                      child: Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                      ),
                    )
                  ),
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: controller,
                      onChanged: (val) {
                        //print('new text: ' + val);
                        setState(() {
                          tagName = val;
                          if (tagWithTitleExists(title: val, tags: data['all_tags']) && val != data['tag'].title) {
                            willHaveDuplicateTag = true;
                          } else {
                            willHaveDuplicateTag = false;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                height: 30
            ),
            willHaveDuplicateTag ? Text('Duplicate tags aren\'t allowed', style: TextStyle(color: Colors.red)) : SizedBox(height: 0),
            MaterialButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () => deleteTag(userId: user.uid),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
