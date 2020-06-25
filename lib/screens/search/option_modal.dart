import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:interestopia/models/tag.dart';


class OptionModal {

  AwesomeDialog dialog;

  static const int NON_SCROLLABLE_LIST = 0;
  static const int SCROLLABLE_LIST = 1;

  List<dynamic> selectedTagIds;

  OptionModal({ BuildContext context, String title, List<String> options, List<Tag> tags, int listType, bool isMultiSelectOn, int selectedIndex, List<dynamic> selectedTagIds, double screenHeight, Function f }) {

    this.selectedTagIds = selectedTagIds;

    dialog = AwesomeDialog(
        context: context,
        useRootNavigator: true,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        body: listType == 0 ?
          _buildOptionList(title: title, options: options, selectedIndex: selectedIndex, f: f) :
          _buildScrollableOptionList(isMultiSelectOn: isMultiSelectOn, screenHeight: screenHeight, title: title, options: options, tags: tags, selectedIndex: selectedIndex, selectedTagIds: selectedTagIds, f: f),
    );
  }

  void addSelectedId({ String id }) {
    selectedTagIds.add(id);
  }

  void removeSelectedId({ String id }) {
    selectedTagIds.remove(id);
  }

  bool isTagSelected({ String id }) {
    return selectedTagIds.contains(id);
  }

  show() {
      dialog.show();
  }

  dismiss() {
    dialog.dissmiss();
  }

  Text buildTitle({ String title }) {
    return Text(
              title,
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
          ));
  }

  Column _buildOptionList({ String title, List<String> options, int selectedIndex, Function f }) {

    Column result;

    List<Widget> childrenWidgets = [];

    childrenWidgets.add(buildTitle(title: title));

    for (int i = 0; i < options.length; i++) {
      if (i != options.length - 1) {
        childrenWidgets.add(buildOptionListItem(index: i, text: options[i], isSelected: i == selectedIndex, f: f));
        childrenWidgets.add(Divider());
      } else {
        childrenWidgets.add(buildOptionListItem(index: i, text: options[i], isSelected: i == selectedIndex, f: f));
      }
    }

    result = Column(children: childrenWidgets);

    return result;
  }

  Row _buildBottomRowForMultiSelectionModal({ List<dynamic> selectedTagIds, Function f }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            color: Colors.white,
            onPressed: selectedTagIds.length == 0 ? null : () {
              f([]);
              dismiss();
            },
            child: Text(
              'Reset',
              style: TextStyle(
                  color: selectedTagIds.length == 0 ? Colors.grey : Colors.deepPurpleAccent
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: selectedTagIds.length == 0 ? Colors.grey : Colors.deepPurpleAccent)
            )
        ),
        SizedBox(width: 10),
        FlatButton(
            color: Colors.white,
            onPressed: selectedTagIds.length == 0 ? null : () {
              f(selectedTagIds);
              dismiss();
            },
            child: Text(
              'Confirm',
              style: TextStyle(
                  color: Colors.deepPurpleAccent
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.deepPurpleAccent)
            )
        )
      ],
    );
  }

  Container _buildScrollableOptionList({ bool isMultiSelectOn, double screenHeight, String title, List<String> options, List<Tag> tags, int selectedIndex, List<dynamic> selectedTagIds, Function f }) {
    return Container(
      height: screenHeight * .40,
      child: Column(
        children: [
            buildTitle(title: title),
            Expanded(
              flex: 2,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  bool isDisplayingTags = isMultiSelectOn;
                  if (!isDisplayingTags) {
                    return buildOptionListItem(hasCheckBox: isMultiSelectOn, index: index, text: options[index], isSelected: index == selectedIndex, f: f);
                  } else {
                    return buildTagListItem(id: tags[index].id, text: tags[index].toString(), isSelected: isTagSelected(id: tags[index].id), f: f);
                  }
                },
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemCount: options != null ? options.length : tags.length,
              ),
            ),
            SizedBox(height: 10),
            !isMultiSelectOn ?
              FlatButton(
                color: Colors.white,
                onPressed: selectedIndex == null ? null : () {
                  f(null);
                  dismiss();
                },
                child: Text(
                    'Reset',
                    style: TextStyle(
                      color: selectedIndex == null ? Colors.grey : Colors.deepPurpleAccent
                    ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: selectedIndex == null ? Colors.grey : Colors.deepPurpleAccent)
                )
              ) :
              _buildBottomRowForMultiSelectionModal(selectedTagIds: selectedTagIds, f: f)
        ],
      ),
    );
  }

  Widget getButtonIcon({ bool isCheckBox, bool isSelected }) {
    if (isCheckBox) {
      if (isSelected) {
        return Icon(Icons.check_box);
      } else {
        return Icon(Icons.check_box_outline_blank);
      }
    } else {
      if (isSelected) {
        return Icon(Icons.radio_button_checked);
      } else {
        return Icon(Icons.radio_button_unchecked);
      }
    }
  }

  ListTile buildTagListItem({ String id, String text, bool isSelected, Function f }) {
    return ListTile(
        title: Text(text),
        onTap: isSelected ? () => removeSelectedId(id: id) : () => addSelectedId(id: id),
        trailing: getButtonIcon(isCheckBox: true, isSelected: isSelected)
    );
  }

  ListTile buildOptionListItem({ bool hasCheckBox, int index, String text, bool isSelected, Function f }) {

    return ListTile(
        title: Text(text),
        onTap: isSelected ? null : ()  {
          f(index);
          dismiss();
        },
        trailing: getButtonIcon(isCheckBox: hasCheckBox, isSelected: isSelected)
    );
  }
}
