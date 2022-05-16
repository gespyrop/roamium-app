import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:roamium_app/src/models/review.dart';
import 'package:roamium_app/src/models/visit.dart';
import 'package:roamium_app/src/repositories/reviews/review_repository.dart';
import 'package:roamium_app/src/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewForm extends StatefulWidget {
  final Visit visit;
  final Review? review;

  const ReviewForm({Key? key, required this.visit, this.review})
      : super(key: key);

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // Review fields
  TextEditingController reviewController = TextEditingController();
  late double stars;

  // Review
  Review? review;

  // UI
  bool loading = false;

  @override
  void initState() {
    stars = widget.review?.stars.toDouble() ?? 0;
    reviewController.text = widget.review?.text ?? '';
    review = widget.review;
    super.initState();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  /// Shows an error snackbar with the given `message`.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _submitReview() async {
    if (_key.currentState!.validate()) {
      if (stars > 0) {
        setState(() => loading = true);

        if (review != null) {
          try {
            Review newReview = Review(
              stars.ceil(),
              reviewController.text,
              id: review!.id,
            );

            // Update the review
            Review updatedReview =
                await context.read<ReviewRepository>().updateReview(newReview);

            setState(() => review = updatedReview);
          } on ReviewUpdateFailure {
            _showErrorSnackBar(AppLocalizations.of(context).reviewUpdateError);
          } finally {
            setState(() => loading = false);
          }
        } else {
          try {
            Review newReview = Review(stars.ceil(), reviewController.text);

            // Create a new review
            Review createdReview = await context
                .read<ReviewRepository>()
                .createReview(widget.visit, newReview);

            setState(() => review = createdReview);
          } on ReviewCreationFailure {
            _showErrorSnackBar(
                AppLocalizations.of(context).reviewCreationError);
          } finally {
            setState(() => loading = false);
          }
        }
      } else {
        _showErrorSnackBar(AppLocalizations.of(context).zeroStarsError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : Form(
            key: _key,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).rateYourVisit,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                RatingBar(
                  minRating: 1,
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: primaryColor),
                    half: const Icon(Icons.star, color: primaryColor),
                    empty: const Icon(Icons.star_outline, color: primaryColor),
                  ),
                  glow: false,
                  initialRating: review?.stars.toDouble() ?? 0,
                  onRatingUpdate: (newStars) =>
                      setState(() => stars = newStars),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 48.0,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: reviewController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      focusColor: primaryColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    minLines: 4,
                    maxLines: 12,
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: Text(AppLocalizations.of(context).submitReview),
                )
              ],
            ),
          );
  }
}
