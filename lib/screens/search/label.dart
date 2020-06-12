import 'package:flutter/material.dart';

class Label extends StatefulWidget {

  String text;
  bool hasLeftMargin = true;
  bool isEstimateLabel = false;

  Label({ this.text });

  Label.noLeftMargin({ String text }) {
    this.text = text;
    this.hasLeftMargin = false;
  }

  Label.isEstimateLabel({ String text}) {
    this.text = text;
    this.hasLeftMargin = false;
    this.isEstimateLabel = true;
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
          color: widget.isEstimateLabel ? Colors.grey[500] : Colors.transparent,
          border: Border.all(color: widget.isEstimateLabel ? Colors.transparent : Colors.grey[500]),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              widget.text,
              style: TextStyle(
                color: widget.isEstimateLabel ? Colors.white : Colors.grey[700]
              )
          ),
        )
      ),
    );
  }
}

