class SavedItem {

  String id; // new
  String url; // new
  String title;
  DateTime dateTimeSaved;
  String description;
  String topic;
  String consumptionOrReference; // new
  String mediaType; // new
  List<dynamic> associatedTagIds; // new
  double progressAmount; // new
  bool isArchived; // new
  bool isFavorited; // new
  String content; // new
  int parsedWordCount; // new

  SavedItem({ String title, DateTime dateTimeSaved, String description, String topic, String consumptionOrReference, List<dynamic> associatedTagIds }) {
    this.title = title;
    this.dateTimeSaved = dateTimeSaved;
    this.description = description;
    this.topic = topic;
    this.consumptionOrReference = consumptionOrReference;
    this.associatedTagIds = associatedTagIds;
  }

}