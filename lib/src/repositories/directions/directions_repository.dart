import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:roamium_app/src/models/directions.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/route.dart';

Map<RouteType, String> routeTypeMap = {
  RouteType.walking: 'foot-walking',
  RouteType.hiking: 'foot-hiking',
  RouteType.car: 'driving-car',
  RouteType.bike: 'cycling-regular',
  RouteType.wheelchair: 'wheelchair',
};

abstract class DirectionsRepository {
  Future<Directions> getDirections({
    required LocationData location,
    required List<Place> route,
    RouteType routeType,
  });
}

class ORSDirectionsRepository implements DirectionsRepository {
  final Dio client;

  ORSDirectionsRepository(this.client);

  @override
  Future<Directions> getDirections({
    required LocationData location,
    required List<Place> route,
    RouteType routeType = RouteType.walking,
  }) async {
    String url = '/directions/${routeTypeMap[routeType]}';

    // API key from https://openrouteservice.org/
    const String apiKey = 'ORS_API_KEY';

    // Add the API key to the Authorization header
    client.options.headers.addAll({'Authorization': apiKey});

    // Prepare coordinates
    List<dynamic> coordinates = [
      [location.longitude, location.latitude]
    ];

    for (Place place in route) {
      coordinates.add([place.longitude, place.latitude]);
    }

    // Get directions
    Map<String, dynamic> data = {
      'coordinates': coordinates,
      'instructions': false,
      'units': 'km',
    };

    Response response = await client.post(url, data: data);

    Map<String, dynamic> routeJson = response.data['routes'][0];

    String encoded = routeJson['geometry'];
    double distance = routeJson['summary']['distance'];
    double duration = routeJson['summary']['duration'];

    PolylinePoints polylinePoints = PolylinePoints();

    return Directions(
      polylinePoints.decodePolyline(encoded),
      distance,
      duration,
    );
  }
}

class DioDirectionsRepository implements DirectionsRepository {
  final Dio client;

  DioDirectionsRepository(this.client);

  @override
  Future<Directions> getDirections({
    required LocationData location,
    required List<Place> route,
    RouteType routeType = RouteType.walking,
  }) async {
    String url = '/place/places/directions/';

    // Prepare points
    List<dynamic> points = [
      [location.longitude, location.latitude]
    ];

    for (Place place in route) {
      points.add([place.longitude, place.latitude]);
    }

    Response response = await client.post(url, data: {
      'points': points,
      'profile': routeTypeMap[routeType],
    });

    return Directions.fromJSON(response.data);
  }
}
