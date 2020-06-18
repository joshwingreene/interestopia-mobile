import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/search_config.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/screens/search/option_modal.dart';
import 'package:interestopia/screens/search/search_bar_area.dart';
import 'package:interestopia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

class Search extends StatefulWidget {

  const Search({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  User user;
  dynamic docStream;

  SearchConfig searchConfig = SearchConfig();

  bool isTagSelectorOn = false;
  bool isTopicSelectorOn = false;
  bool isMediaTypeSelectorOn = false;
  bool isFavoritedToggleOn = false;
  bool isArchivedToggleOn = false;

  OptionModal dialog;

  @override
  void initState() {
    //print('Search - initState');
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) { // Needed in order to do the included code only after super.initState has been completed
      // accesses the user data from the provider
      this.user = Provider.of<User>(context, listen: false); // listen is needed in order to use Provider.of in initState

      this.docStream = DatabaseService(uid: this.user.uid).listenToDocumentChanges();
    });
  }

  @override
  void dispose() {
    print('dispose');
    if (docStream != null)
      //print('docStream != null'); // called - so this is working as it should
      docStream.cancel();
    super.dispose();
  }

  void changePurposeState( int index ) {

    switch(index) {
      case SearchConfig.CONSUMPTION:
        //print('for consumption');
        setState(() {
          searchConfig.changePurposeMode(SearchConfig.CONSUMPTION);
        });
        break;
      case SearchConfig.REFERENCE:
        //print('for reference');
        setState(() {
          searchConfig.changePurposeMode(SearchConfig.REFERENCE);
        });
        break;
      case SearchConfig.ALL:
        //print('all items');
        setState(() {
          searchConfig.changePurposeMode(SearchConfig.ALL);
        });
        break;
      default:
        return;
    }
  }

  void tapConsumptionVsReferenceToggle() {
    print('For Consumption vs Reference vs All toggle');

    dialog = OptionModal(
      context: context,
      title: 'Filter by Purpose',
      options: SearchConfig.purposeOptions,
      selectedIndex: searchConfig.getCurrentPurpose(),
      f: changePurposeState
    );

    dialog.show();
  }

  updateSortOrder(int order) {
    setState(() {
      searchConfig.setSortOrder(order);
    });
  }

  void tapDateTimeSortToggle() {
    print('DateTimeSaved toggle');

    dialog = OptionModal(context: context,
        title: 'Sort Order',
        options: SearchConfig.sortOrderOptions,
        selectedIndex: searchConfig.getSelectedSortOrder(),
        f: updateSortOrder
    );

    dialog.show();
  }

  /*Container( // was assigned to the above AwesomeDialog's body property
        height: 200, // TODO: Use MeasureSize in order to get the height of the SafeArea and use it to know how big this dialog should be
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(consRefAllModes[index]),
                  onTap: consRefAllModes[index] == consRefAllModes[searchConfig.getConfRefAllMode()] ? null : ()  {

                    changeConRefAllState(index: index);

                    dismissDialog(dialogVar: dialog);
                  },
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: consRefAllModes.length,
        ),
      ), */

  void tapTagSelector() { // Should support multiple tags being selected // TODO - (left the commented out code above for reference) Will need to use a container and a height around the tags listview
    print('Tag Selector button');
    setState(() {
      isTagSelectorOn = !isTagSelectorOn;
    });
  }

  void tapTopicSelector() { // Only support one topic being selected
    print('Topic Selector button');
    setState(() {
      isTopicSelectorOn = !isTopicSelectorOn;
    });
  }

  void tapMediaTypeSelector() { // Only support one media type being selected
    print('Media Type Selector button');
    setState(() {
      isMediaTypeSelectorOn = !isMediaTypeSelectorOn;
    });
  }

  void tapFavoritedToggle() {
    print('Favorited toggle');
    setState(() {
      isFavoritedToggleOn = !isFavoritedToggleOn;
    });
  }

  void tapArchivedToggle() {
    print('Archived toggle');
    setState(() {
      isArchivedToggleOn = !isArchivedToggleOn;
    });
  }

  FlatButton buildHorizontalOptionButton({String title, bool hasStartingValue, IconData icon, Function f, bool isOn}) {
    return FlatButton(
      color: isOn ? Colors.deepPurpleAccent : Colors.transparent,
      onPressed: () => f(),
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

    this.user = Provider.of<User>(context); // needed during the initial call of build

    return StreamProvider<List<SavedItem>>.value(
      value: DatabaseService(uid: this.user.uid).savedItems,
      child: StreamProvider<List<Tag>>.value(
        value: DatabaseService(uid: this.user.uid).tags,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(15),
            child: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              brightness: Theme.of(context).brightness,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Container(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        buildHorizontalOptionButton(title: searchConfig.getSelectedPurposeOption(), f: this.tapConsumptionVsReferenceToggle, isOn: true),
                        SizedBox(width: 10),
                        buildHorizontalOptionButton(title: searchConfig.getSelectedSortOrderOption(), f: this.tapDateTimeSortToggle, isOn: true),
                        SizedBox (width: 10),
                        buildHorizontalOptionButton(title: 'Tag', f: this.tapTagSelector, isOn: this.isTagSelectorOn),
                        SizedBox (width: 10),
                        buildHorizontalOptionButton(title: 'Topic', f: this.tapTopicSelector, isOn: this.isTopicSelectorOn),
                        SizedBox (width: 10),
                        buildHorizontalOptionButton(title: 'Media Type', f: this.tapMediaTypeSelector, isOn: this.isMediaTypeSelectorOn),
                        SizedBox (width: 10),
                        buildSquareHorizontalOptionButton(icon: Icons.star, f: this.tapFavoritedToggle, currentlyBeingUsed: isFavoritedToggleOn),
                        SizedBox (width: 10),
                        buildSquareHorizontalOptionButton(icon: Icons.check, f: this.tapArchivedToggle, currentlyBeingUsed: isArchivedToggleOn),
                        SizedBox (width: 13)
                      ],
                    )
                  ),
                ),
                Expanded( // The quick, baby pool fix is to change the mainAxisSize of theRow/Column to MainAxisSize.min, then wrap the child that wants to be infinitely large in an Expanded. - https://medium.com/flutter-community/flutter-deep-dive-part-1-renderflex-children-have-non-zero-flex-e25ffcf7c272
                  flex: 15,
                  child: SearchBarArea(currentSearchConfig: searchConfig)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

