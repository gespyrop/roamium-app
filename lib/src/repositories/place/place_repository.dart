import 'package:dio/dio.dart';
import 'package:roamium_app/src/models/category.dart';

abstract class PlaceRepository {
  Future<List<Category>> getNearbyCategories({
    required double longitude,
    required double latitude,
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
}
