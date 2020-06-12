import 'package:flutter/material.dart';

class Label extends StatefulWidget {

  String text;
  bool hasLeftMargin = true;

  Label({ this.text });

  Label.noLeftMargin({ String text }) {
    this.text = text;
    this.hasLeftMargin = false;
  }

  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.hasLeftMargin ? EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0) : EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.grey[700]
              )
          ),
        )
      ),
    );
  }
}

