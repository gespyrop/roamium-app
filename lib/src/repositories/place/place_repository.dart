import 'package:dio/dio.dart';
import 'package:roamium_app/src/models/category.dart';
import 'package:roamium_app/src/models/place.dart';

abstract class PlaceRepository {
  Future<List<Category>> getNearbyCategories({
    required double longitude,
    required double latitude,
  });

  Future<List<Place>> recommendPlaces({
    required double longitude,
    required double latitude,
    List<Category> categories,
    bool wheelchair,
  });
}

class DioPlaceRepository implements PlaceRepository {
  final Dio client;

  DioPlaceRepository(this.client);

  @override
  Future<List<Category>> getNearbyCategories({
    required double longitude,
    required double latitude,
  }) async {
    Response response = await client.get(
        '/place/places/nearby/categories/?longitude=$longitude&latitude=$latitude');

    return List.generate(
      response.data.length,
      (index) => Category(response.data[index]),
    );
  }

  List<Place> _parsePlaces(List<dynamic> json) =>
      List.generate(json.length, (index) => Place.fromJSON(json[index]));

  @override
  Future<List<Place>> recommendPlaces({
    required double longitude,
    required double latitude,
    List<Category> categories = const [],
    bool wheelchair = false,
  }) async {
    Response response = await client.post(
      '/place/places/recommend/?longitude=$longitude&latitude=$latitude',
      data: {
        'categories': categories.map((category) => category.name).toList(),
        'wheelchair': wheelchair ? 2 : 0,
      },
    );

    return _parsePlaces(response.data);
  }
}
