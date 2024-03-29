import 'package:dio/dio.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/route.dart';
import 'package:roamium_app/src/models/visit.dart';

part 'exceptions.dart';

abstract class RouteRepository {
  /// Creates a new route.
  Future<Route> createRoute(List<Place> places, {RouteType routeType});

  /// Creates a visit for the given place.
  Future<Visit> visitPlace(Route route, Place place);

  /// Completes a route.
  Future<Route> completeRoute(Route route);

  /// Get the user's routes.
  Future<List<Route>> getRoutes();
}

class DioRouteRepository implements RouteRepository {
  final Dio client;

  DioRouteRepository(this.client);

  @override
  Future<Route> createRoute(List<Place> places,
      {RouteType routeType = RouteType.walking}) async {
    String endpoint = '/route/routes/';

    try {
      Response response = await client.post(endpoint);
      int id = response.data['id'];

      return Route(id, places: places, type: routeType);
    } on DioError {
      throw RouteCreationException();
    }
  }

  @override
  Future<Visit> visitPlace(Route route, Place place) async {
    String endpoint = '/route/visits/';

    Visit visit = Visit.fromPlace(place);

    Map<String, dynamic> data = visit.toJson();
    data['route'] = route.id;

    try {
      Response response = await client.post(endpoint, data: data);

      return Visit.fromJson(response.data);
    } on DioError {
      throw VisitException();
    }
  }

  @override
  Future<Route> completeRoute(Route route) async {
    String endpoint = '/route/routes/${route.id}/complete/';

    try {
      Response response = await client.post(endpoint);

      // Empty routes get deleted
      if (response.statusCode == 204) throw EmptyRouteException();

      return Route.fromJson(response.data);
    } on DioError {
      throw RouteCompletionException();
    }
  }

  @override
  Future<List<Route>> getRoutes() async {
    String endpoint = '/route/routes';

    Response response = await client.get(endpoint);
    List<dynamic> data = response.data;

    return List.generate(data.length, (index) => Route.fromJson(data[index]))
        .reversed
        .toList();
  }
}
