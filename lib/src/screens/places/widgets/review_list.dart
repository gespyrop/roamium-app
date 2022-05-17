import 'package:flutter/material.dart';
import 'package:roamium_app/src/models/review.dart';
import 'package:roamium_app/src/theme/colors.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;

  const ReviewList({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Review review = reviews[index];

          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(review.text),
              trailing: Text(
                '${review.stars} ★',
                style: const TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          );
        },
        itemCount: reviews.length,
      ),
    );
  }
}
