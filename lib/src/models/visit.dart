import 'package:intl/intl.dart';
import 'package:roamium_app/src/models/place.dart';

class Visit {
  final int? id;
  final int placeId;
  final String placeSource, name;
  final DateTime? timestamp;

  String getTimestampString({String locale = 'en'}) {
    return timestamp != null
        ? DateFormat('EEEE dd-mm-yyyy H:m', locale).format(timestamp!)
        : '';
  }

  Visit(
    this.placeId,
    this.placeSource,
    this.name, {
    this.id,
    this.timestamp,
  });

  Visit.fromPlace(Place place)
      : placeId = place.id,
        placeSource = place.source,
        name = place.name,
        id = null,
        timestamp = null;

  Visit.fromJson(Map<String, dynamic> json)
      : placeId = json['place_id'],
        placeSource = json['place_source'],
        name = json['name'],
        id = json['id'],
        timestamp = DateTime.parse(json['timestamp']);

  Map<String, dynamic> toJson() => {
        'place_id': placeId,
        'place_source': placeSource,
        'name': name,
      };
}
