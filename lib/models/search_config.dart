class SearchConfig {

  // CONSTANTS
  static const int CONSUMPTION = 0;
  static const int REFERENCE = 1;
  static const int ALL = 2;

  static const int NEWEST_FIRST = 0;
  static const int OLDEST_FIRST = 1;

  static const int WEB_PAGE = 0;
  static const int ONLINE_VIDEO = 1;
  static const int IMAGE = 2;
  static const int PDF = 3;
  static const int PODCAST = 4;
  static const int NEWSLETTER = 5;

  // Fields
  int _consRefAllMode;
  int _sortOrder;
  List<String> _selectedTags = [];
  String _selectedTopic;
  int _mediaType;
  bool _onlyFavorites = false;
  bool _onlyArchived = false;

  SearchConfig() {
    _consRefAllMode = CONSUMPTION;
    _sortOrder = NEWEST_FIRST;
  }

  void changeConfRefAllMode({ int mode }) {
    _consRefAllMode = mode;
  }

  int getConfRefAllMode() {
    return _consRefAllMode;
  }
}