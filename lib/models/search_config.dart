class SearchConfig {

  // CONSTANTS
  static const int CONSUMPTION = 0;
  static const int REFERENCE = 1;
  static const int ALL = 2;
  static List<String> purposeOptions = ['For Consumption', 'For Reference', 'All Items (both options)'];

  static const int NEWEST_FIRST = 0;
  static const int OLDEST_FIRST = 1;
  static List<String> sortOrderOptions = ['Newest to Oldest', 'Oldest to Newest'];

  static const int WEB_PAGE = 0;
  static const int ONLINE_VIDEO = 1;
  static const int IMAGE = 2;
  static const int PDF = 3;
  static const int PODCAST = 4;
  static const int NEWSLETTER = 5;

  // Fields
  int _selectedPurpose;
  int _sortOrder;
  List<String> _selectedTags = [];
  String _selectedTopic;
  int _mediaType;
  bool _onlyFavorites = false;
  bool _onlyArchived = false;

  SearchConfig() {
    _selectedPurpose = CONSUMPTION;
    _sortOrder = NEWEST_FIRST;
  }

  void changePurposeMode({ int mode }) {
    _selectedPurpose = mode;
  }

  int getCurrentPurpose() {
    return _selectedPurpose;
  }

  String getSelectedPurposeOption() {
    return purposeOptions[_selectedPurpose];
  }

  int getSelectedSortOrder() {
    return _sortOrder;
  }

  String getSelectedSortOrderOption() {
    return sortOrderOptions[_sortOrder];
  }

  void setSortOrder(order) {
    _sortOrder = order;
  }
}