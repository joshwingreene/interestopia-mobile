import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';


class OptionModal {

  AwesomeDialog dialog;

  static const int NON_SCROLLABLE_LIST = 0;
  static const int SCROLLABLE_LIST = 1;

  OptionModal({ BuildContext context, String title, List<String> options, int selectedIndex, int listType, List<int> selectedIndexes, double screenHeight, Function f }) {

    dialog = AwesomeDialog(
        context: context,
        useRootNavigator: true,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        body: listType == 0 ?
          _buildOptionList(title: title, options: options, selectedIndex: selectedIndex, f: f) :
          _buildScrollableOptionList(screenHeight: screenHeight, title: title, options: options, selectedIndex: selectedIndex, f: f),
    );
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

  Container _buildScrollableOptionList({ double screenHeight, String title, List<String> options, int selectedIndex, Function f }) {
    return Container(
      height: screenHeight * .40,
      child: Column(
        children: [
            buildTitle(title: title),
            Expanded(
              flex: 2,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return buildOptionListItem(index: index, text: options[index], isSelected: index == selectedIndex, f: f);
                },
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemCount: options.length,
              ),
            ),
            SizedBox(height: 10),
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
            )
        ],
      ),
    );
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
}
