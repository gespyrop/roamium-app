import 'package:dio/dio.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/review.dart';
import 'package:roamium_app/src/models/visit.dart';

part 'exceptions.dart';

abstract class ReviewRepository {
  /// Get the review of a specific visit.
  Future<Review> getReview(Visit visit);

  /// Get the reviews of a specific place.
  Future<List<Review>> getReviews(Place place);

  /// Create a review for a visit.
  Future<Review> createReview(Visit visit, Review review);

  /// Update a review for a visit.
  Future<Review> updateReview(Review review);
}

class DioReviewRepository implements ReviewRepository {
  final Dio client;

  DioReviewRepository(this.client);

  @override
  Future<Review> getReview(Visit visit) async {
    String endpoint = '/route/visits/${visit.id}/review/';

    try {
      Response response = await client.get(endpoint);
      return Review.fromJSON(response.data);
    } on DioError {
      throw ReviewNotFound();
    }
  }

  @override
  Future<List<Review>> getReviews(Place place) async {
    String endpoint =
        '/route/reviews/place/?source=${place.source}&place_id=${place.id}';

    try {
      Response response = await client.get(endpoint);

      return List.generate(
        response.data.length,
        (index) => Review.fromJSON(response.data[index]),
      );
    } on DioError {
      throw FetchReviewsFailure();
    }
  }

  @override
  Future<Review> createReview(Visit visit, Review review) async {
    String endpoint = '/route/reviews/';

    try {
      Map<String, dynamic> data = review.toJSON();
      data['visit'] = visit.id;

      Response response = await client.post(endpoint, data: data);

      return Review.fromJSON(response.data);
    } on DioError {
      throw ReviewCreationFailure();
    }
  }

  @override
  Future<Review> updateReview(Review review) async {
    String endpoint = '/route/reviews/${review.id}/';

    try {
      Response response = await client.patch(endpoint, data: review.toJSON());

      return Review.fromJSON(response.data);
    } on DioError {
      throw ReviewUpdateFailure();
    }
  }
}
