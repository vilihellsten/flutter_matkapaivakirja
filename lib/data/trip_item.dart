class TripItem {
  int id = 0;
  String title = '';
  String description = '';
  DateTime date = DateTime.now();

  double latitude = 0.0;
  double longitude = 0.0;

  String? fbId;
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
}
