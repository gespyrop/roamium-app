import 'package:intl/intl.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/visit.dart';

class Route {
  final int id;
  final List<Place> places;
  final List<Visit> visits;

  String getTimestampString({String locale = 'en'}) {
    DateTime? lastTimestamp = visits.last.timestamp;

    return lastTimestamp != null
        ? DateFormat('EEEE dd-mm-yyyy H:m', locale).format(lastTimestamp)
        : '';
  }

  Route(
    this.id, {
    this.places = const [],
    this.visits = const [],
  });

  Route.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        places = [],
        visits = List.generate(
          (json['visits'] as List<dynamic>).length,
          (index) => Visit.fromJson(json['visits'][index]),
        );

  Route.copyWithVisits(Route route, List<Visit> newVisits)
      : id = route.id,
        places = route.places,
        visits = newVisits;

  bool isVisited(Place place) =>
      visits.indexWhere((visit) =>
          visit.placeId == place.id && visit.placeSource == place.source) !=
      -1;
}
