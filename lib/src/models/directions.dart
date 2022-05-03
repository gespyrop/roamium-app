import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Directions {
  final List<PointLatLng> polylineCoordinates;
  final double distance, duration;

  Directions(this.polylineCoordinates, this.distance, this.duration);

  Directions.fromJSON(Map<String, dynamic> json)
      : polylineCoordinates = PolylinePoints().decodePolyline(json['geometry']),
        distance = json['distance'],
        duration = json['duration'];
}
