class TripItem {
  int id = 0;
  String title = '';
  String description = '';
  DateTime date = DateTime.now();

  double latitude = 0.0;
  double longitude = 0.0;

  String? fbid;
  String? ownerId;

  TripItem({
    this.id = 0,
    required this.title,
    required this.description,
    required this.date,
    //required this.latitude,
    //required this.longitude,
  });

  Map<String, dynamic> toMap() {
    // tarkista
    return {
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
    };
  }

  TripItem.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        description = json['description'],
        date = DateTime.parse(json['date'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "title": title,
        "description": description,
        "date": date.toString(),
      };
}
