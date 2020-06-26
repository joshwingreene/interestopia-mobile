class SavedItem {

  String id; // new
  String url; // new
  String title;
  DateTime dateTimeSaved;
  String description;
  String topic;
  String consumptionOrReference; // new
  String mediaType; // new // TODO - (sticking with a String for now since the consts could be made into Strings) Thinking about making this an int, especially with what I'm doing in SearchConfig
  List<dynamic> associatedTagIds; // new
  double progressAmount; // new
  bool isArchived; // new
  bool isFavorited; // new
  String content; // new (will be overwritten with the parsed content from the parsing server)(I don't want to save data twice.)
  int parsedWordCount; // new

  SavedItem({ String title, DateTime dateTimeSaved, String description,
              String topic, String consumptionOrReference, List<dynamic> associatedTagIds,
              String mediaType, bool isFavorited, bool isArchived }) {
    this.title = title;
    this.dateTimeSaved = dateTimeSaved;
    this.description = description;
    this.topic = topic;
    this.consumptionOrReference = consumptionOrReference;
    this.associatedTagIds = associatedTagIds;
    this.mediaType = mediaType;
    this.isFavorited = isFavorited;
    this.isArchived = isArchived;
  }

}