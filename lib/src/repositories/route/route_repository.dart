import 'package:dio/dio.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/route.dart';
import 'package:roamium_app/src/models/visit.dart';

abstract class RouteRepository {
  /// Creates a new route.
  Future<Route> createRoute(List<Place> places);

  /// Creates a visit for the given place.
  Future<Visit> visitPlace(Route route, Place place);

  /// Completes a route.
  Future<Route> completeRoute(Route route);
}

class DioRouteRepository implements RouteRepository {
  final Dio client;

  DioRouteRepository(this.client);

  @override
  Future<Route> createRoute(List<Place> places) async {
    String endpoint = '/route/routes/';

    Response response = await client.post(endpoint);
    int id = response.data['id'];

    return Route(id, places: places);
  }

  @override
  Future<Visit> visitPlace(Route route, Place place) async {
    String endpoint = '/route/visits/';

    Visit visit = Visit.fromPlace(place);

    Map<String, dynamic> data = visit.toJson();
    data['route'] = route.id;

    Response response = await client.post(endpoint, data: data);

    return Visit.fromJson(response.data);
  }

  @override
  Future<Route> completeRoute(Route route) async {
    String endpoint = '/route/routes/${route.id}/complete/';

    Response response = await client.post(endpoint);

    return Route.fromJson(response.data);
  }
}
