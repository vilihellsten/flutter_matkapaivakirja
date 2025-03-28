import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripItem {
  int id = 0;
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  bool? julkinen = false;

  LatLng? location;

  String? fbid;
  String? ownerId;
  String? imageUrl;

  TripItem({
    this.id = 0,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.julkinen,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    // tarkista
    return {
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'location': location != null
          ? {'latitude': location!.latitude, 'longitude': location!.longitude}
          : null,
      'julkinen': julkinen,
      'imageUrl': imageUrl,
    };
  }

  TripItem.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        description = json['description'],
        date = DateTime.parse(json['date'] as String),
        location = json['location'] != null
            ? LatLng(
                json['location']['latitude'] as double,
                json['location']['longitude'] as double,
              )
            : null, // Deserialize LatLng from a map
        julkinen = json['julkinen'],
        imageUrl = json['imageUrl'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        "title": title,
        "description": description,
        "date": date.toString(),
        'location': location != null
            ? {'latitude': location!.latitude, 'longitude': location!.longitude}
            : null, // Serialize LatLng as a map
        'julkinen': julkinen,
        'imageUrl': imageUrl,
      };
}
