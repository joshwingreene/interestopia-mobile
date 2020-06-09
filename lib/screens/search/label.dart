import 'package:flutter/material.dart';

class Label extends StatefulWidget {

  final String text;

  const Label({ this.text });

  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.text),
      )
    );
  }
}

