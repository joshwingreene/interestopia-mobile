import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';


class OptionModal {

  AwesomeDialog dialog;

  OptionModal({ BuildContext context, String title, List<String> options, int selectedIndex, List<int> selectedIndexes, Function f }) {

    dialog = AwesomeDialog(
        context: context,
        useRootNavigator: true,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        body: _buildOptionList(title: title, options: options, selectedIndex: selectedIndex, f: f)
    );
  }

  show() {
      dialog.show();
  }

  dismiss() {
    dialog.dissmiss();
  }

  Column _buildOptionList({ String title, List<String> options, int selectedIndex, Function f }) {

    Column result;

    List<Widget> childrenWidgets = [];

    childrenWidgets.add(Text(title,
        style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18
        )));

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

  ListTile buildOptionListItem({ int index, String text, bool isSelected, Function f }) {

    return ListTile(
        title: Text(text),
        onTap: isSelected ? null : ()  {
          f(index);
          dismiss();
        },
        trailing: isSelected ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_unchecked)
    );
  }

  /*
  ListTile buildOptionListItem({ int index, String trailingText }) {

    bool isSelected = consRefAllModes[index] == consRefAllModes[searchConfig.getConfRefAllMode()];

    return ListTile(
        title: Text(trailingText == null ? consRefAllModes[index] : consRefAllModes[index] + trailingText),
        onTap: isSelected ? null : ()  {

          changeConRefAllState(index: index);

          dialog.dissmiss();
        },
        trailing: isSelected ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_unchecked)
    );
  }
   */

}
