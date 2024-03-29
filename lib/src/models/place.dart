import 'package:roamium_app/src/models/category.dart';

class Place {
  final int id;
  final String name;
  final List<Category> categories;
  final String source;
  final String? wheelchair;
  final double longitude, latitude, distance;
  final double? score, rating;

  String get summary => 'Score: $score | Categories: ${categories.join(",")}';

  Place(this.id, this.name, this.categories, this.source, this.wheelchair,
      this.longitude, this.latitude, this.distance, this.score, this.rating);

  Place.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categories = List.generate(
          json['categories'].length,
          (index) => Category(json['categories'][index]),
        ),
        source = json['source'],
        wheelchair = json['wheelchair'],
        longitude = json['location']['longitude'],
        latitude = json['location']['latitude'],
        distance = json['distance'],
        score = json['score'],
        rating = json['rating'];
}
