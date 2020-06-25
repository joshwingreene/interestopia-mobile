import 'package:flutter/material.dart';
import 'package:interestopia/models/search_config.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/shared/constants.dart';
import 'package:provider/provider.dart';

class HorizontalOptionsList extends StatefulWidget {

  HorizontalOptionsList({
    this.currentSearchConfig,
    this.tapConsumptionVsReferenceToggle,
    this.tapDateTimeSortToggle,
    this.tapTagSelector,
    this.tapTopicSelector,
    this.tapMediaTypeSelector,
    this.tapFavoritedToggle,
    this.tapArchivedToggle,
    this.isTagSelectorOn,
    this.isTopicSelectorOn,
    this.isMediaTypeSelectorOn,
    this.isFavoritedToggleOn,
    this.isArchivedToggleOn
  });

  SearchConfig currentSearchConfig;

  Function tapConsumptionVsReferenceToggle;
  Function tapDateTimeSortToggle;
  Function tapTagSelector;
  Function tapTopicSelector;
  Function tapMediaTypeSelector;
  Function tapFavoritedToggle;
  Function tapArchivedToggle;

  bool isTagSelectorOn;
  bool isTopicSelectorOn;
  bool isMediaTypeSelectorOn;
  bool isFavoritedToggleOn;
  bool isArchivedToggleOn;

  @override
  _HorizontalOptionsListState createState() => _HorizontalOptionsListState();
}

class _HorizontalOptionsListState extends State<HorizontalOptionsList> {

  FlatButton buildHorizontalOptionButton({String title, bool hasStartingValue, IconData icon, Function f, bool isOn, var functionArgs}) {
    return FlatButton(
        color: isOn ? Colors.deepPurpleAccent : Colors.transparent,
        onPressed: functionArgs != null ? () => f(functionArgs) : () => f(),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOn ? Colors.white : Colors.deepPurpleAccent),
            ),
            SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, color: isOn ? Colors.white : Colors.deepPurpleAccent)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isOn ? Colors.transparent : Colors.deepPurpleAccent),
        ));
  }

  MaterialButton buildSquareHorizontalOptionButton({ IconData icon, Function f, bool currentlyBeingUsed}) {
    return MaterialButton(
      color: currentlyBeingUsed ? Colors.deepPurpleAccent : Colors.white,
      height: 50,
      minWidth: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: currentlyBeingUsed ? Colors.white : Colors.deepPurpleAccent),
      ),
      onPressed: () => f(),
      child: Icon(
        icon,
        color: currentlyBeingUsed ? Colors.white : Colors.deepPurpleAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final tags = Provider.of<List<Tag>>(context);

    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        buildHorizontalOptionButton(title: widget.currentSearchConfig.getSelectedPurposeOption(), f: widget.tapConsumptionVsReferenceToggle, isOn: true),
        SizedBox(width: 10),
        buildHorizontalOptionButton(title: widget.currentSearchConfig.getSelectedSortOrderOption(), f: widget.tapDateTimeSortToggle, isOn: true),
        SizedBox (width: 10),
        buildHorizontalOptionButton(title: 'Tag', f: widget.tapTagSelector, functionArgs: tags, isOn: widget.isTagSelectorOn),
        SizedBox (width: 10),
        buildHorizontalOptionButton(title: widget.currentSearchConfig.getSelectedTopicIndex() == null ? 'Topic' : topicList[widget.currentSearchConfig.getSelectedTopicIndex()].title, f: widget.tapTopicSelector, isOn: widget.isTopicSelectorOn),
        SizedBox (width: 10),
        buildHorizontalOptionButton(title: 'Media Type', f: widget.tapMediaTypeSelector, isOn: widget.isMediaTypeSelectorOn),
        SizedBox (width: 10),
        buildSquareHorizontalOptionButton(icon: Icons.star, f: widget.tapFavoritedToggle, currentlyBeingUsed: widget.isFavoritedToggleOn),
        SizedBox (width: 10),
        buildSquareHorizontalOptionButton(icon: Icons.check, f: widget.tapArchivedToggle, currentlyBeingUsed: widget.isArchivedToggleOn),
        SizedBox (width: 13)
      ],
    );
  }
}
