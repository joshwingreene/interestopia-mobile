import 'package:flutter/material.dart';
import 'package:interestopia/models/destination.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/search_config.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/screens/search/horizontal_options_list.dart';
import 'package:interestopia/screens/search/option_modal.dart';
import 'package:interestopia/screens/search/search_bar_area.dart';
import 'package:interestopia/services/database.dart';
import 'package:interestopia/shared/measure_size.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:interestopia/shared/constants.dart';

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
  double safeAreaHeight;

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
      listType: OptionModal.NON_SCROLLABLE_LIST,
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
        listType: OptionModal.NON_SCROLLABLE_LIST,
        options: SearchConfig.sortOrderOptions,
        selectedIndex: searchConfig.getSelectedSortOrder(),
        f: updateSortOrder
    );

    dialog.show();
  }

  void tapTagSelector(List<Tag> tags) { // Should support multiple tags being selected
    print('Tag Selector button');
    dialog = null;
    dialog = OptionModal(
        context: context,
        title: 'Filter by Tag(s)',
        listType: OptionModal.SCROLLABLE_LIST,
        isMultiSelectOn: true,
        tags: tags,
        selectedTagIds: searchConfig.getSelectedTagIds(),
        screenHeight: safeAreaHeight,
        f: updateSelectedTagIds
    );
    dialog.show();
  }

  void updateSelectedTagIds(selectedTagIds) {
    print('updateSelectedTagIds - selected tag ids: ' + selectedTagIds.toString());
    setState(() {
      searchConfig.setSelectedTagIds(selectedTagIds);
      isTagSelectorOn = selectedTagIds.length != 0;
    });
  }

  void tapTopicSelector() { // Only support one topic being selected
    print('Topic Selector button');

    print('screenHeight: ' + safeAreaHeight.toString());

    dialog = OptionModal(
      context: context,
      title: 'Filter by Topic',
      listType: OptionModal.SCROLLABLE_LIST,
      isMultiSelectOn: false,
      options: topicList.map((topic) => topic.title).toList(),
      selectedIndex: searchConfig.getSelectedTopicIndex(),
      screenHeight: safeAreaHeight,
      f: updateSelectedTopic
    );

    dialog.show();
  }

  void updateSelectedTopic(int topicIndex) {
    print('updateSelectedTopic');

    setState(() {
      searchConfig.setSelectedTopicIndex(topicIndex);
      isTopicSelectorOn = topicIndex != null;
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
          body: MeasureSize(
            onChange: (size) {
              print('SafeArea height: ' + size.height.toString());
              setState(() {
                safeAreaHeight = size.height;
              });
            },
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Container(
                      height: 50,
                      child: HorizontalOptionsList(
                        currentSearchConfig: searchConfig,
                          tapConsumptionVsReferenceToggle: tapConsumptionVsReferenceToggle,
                          tapDateTimeSortToggle: tapDateTimeSortToggle,
                          tapTagSelector: tapTagSelector,
                          tapTopicSelector: tapTopicSelector,
                          tapMediaTypeSelector: tapMediaTypeSelector,
                          tapFavoritedToggle: tapFavoritedToggle,
                          tapArchivedToggle: tapArchivedToggle,
                          isTagSelectorOn: isTagSelectorOn,
                          isTopicSelectorOn: isTopicSelectorOn,
                          isMediaTypeSelectorOn: isMediaTypeSelectorOn,
                          isFavoritedToggleOn: isFavoritedToggleOn,
                          isArchivedToggleOn: isArchivedToggleOn
                      )
                      /*
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          buildHorizontalOptionButton(title: searchConfig.getSelectedPurposeOption(), f: this.tapConsumptionVsReferenceToggle, isOn: true),
                          SizedBox(width: 10),
                          buildHorizontalOptionButton(title: searchConfig.getSelectedSortOrderOption(), f: this.tapDateTimeSortToggle, isOn: true),
                          SizedBox (width: 10),
                          buildHorizontalOptionButton(title: 'Tag', f: this.tapTagSelector, isOn: this.isTagSelectorOn),
                          SizedBox (width: 10),
                          buildHorizontalOptionButton(title: searchConfig.getSelectedTopicIndex() == null ? 'Topic' : topicList[searchConfig.getSelectedTopicIndex()].title, f: this.tapTopicSelector, isOn: this.isTopicSelectorOn),
                          SizedBox (width: 10),
                          buildHorizontalOptionButton(title: 'Media Type', f: this.tapMediaTypeSelector, isOn: this.isMediaTypeSelectorOn),
                          SizedBox (width: 10),
                          buildSquareHorizontalOptionButton(icon: Icons.star, f: this.tapFavoritedToggle, currentlyBeingUsed: isFavoritedToggleOn),
                          SizedBox (width: 10),
                          buildSquareHorizontalOptionButton(icon: Icons.check, f: this.tapArchivedToggle, currentlyBeingUsed: isArchivedToggleOn),
                          SizedBox (width: 13)
                        ],
                      )
                       */
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
      ),
    );
  }
}

