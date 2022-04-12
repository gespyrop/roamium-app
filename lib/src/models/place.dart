import 'package:roamium_app/src/models/category.dart';

class Place {
  final int id;
  final String name;
  final List<Category> categories;
  final String? wheelchair;
  final double longitude, latitude, distance;
  final double? score;

  String get summary => 'Score: $score | Categories: ${categories.join(",")}';

  Place(this.id, this.name, this.categories, this.wheelchair, this.longitude,
      this.latitude, this.distance, this.score);

  Place.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categories = List.generate(
          json['categories'].length,
          (index) => Category(json['categories'][index]),
        ),
        wheelchair = json['wheelchair'],
        longitude = json['location']['longitude'],
        latitude = json['location']['latitude'],
        distance = json['distance'],
        score = json['score'];
}
