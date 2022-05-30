import 'package:intl/intl.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/visit.dart';

enum RouteType {
  walking,
  hiking,
  car,
  bike,
  wheelchair,
}

class Route {
  final int id;
  final List<Place> places;
  final List<Visit> visits;
  final RouteType type;

  String getTimestampString({String locale = 'en'}) {
    DateTime? lastTimestamp = visits.isNotEmpty ? visits.last.timestamp : null;

    return lastTimestamp != null
        ? DateFormat('EEEE dd-MM-yyyy H:m', locale).format(lastTimestamp)
        : '';
  }

  Route(this.id,
      {this.places = const [],
      this.visits = const [],
      this.type = RouteType.walking});

  Route.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        places = [],
        type = json['route_type'] ?? RouteType.walking,
        visits = List.generate(
          (json['visits'] as List<dynamic>).length,
          (index) => Visit.fromJson(json['visits'][index]),
        );

  Route.copyWithVisits(Route route, List<Visit> newVisits)
      : id = route.id,
        places = route.places,
        type = route.type,
        visits = newVisits;

  bool isVisited(Place place) =>
      visits.indexWhere((visit) =>
          visit.placeId == place.id && visit.placeSource == place.source) !=
      -1;
}
