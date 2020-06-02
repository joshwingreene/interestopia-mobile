import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';

class EditTag extends StatefulWidget {

  const EditTag({ this.destination, this.tagId }); // I removed the key portion of this line to solve that duplicate global key issue

  final Destination destination;

  final String tagId;

  @override
  _EditTagState createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {

  Map data = {};

  bool isConfirmButtonActive() {
    return false;
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;

    print('tag Id: ' + data['tagId']);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Theme.of(context).brightness,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          MaterialButton(
              onPressed: isConfirmButtonActive() ? () => print('Confirm') : null,
              child: Text(
                'Confirm',
                style: TextStyle(
                    color: isConfirmButtonActive() ? Colors.white : Colors.grey[400],
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
              height: 20
            ),
            Text('tag area'),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.red
              ),
            )
          ],
        )
      ),
    );
  }
}
