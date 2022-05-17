import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/review.dart';
import 'package:roamium_app/src/repositories/reviews/review_repository.dart';
import 'package:roamium_app/src/screens/places/widgets/review_list.dart';
import 'package:roamium_app/src/theme/colors.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailScreen({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32.0),
              const Icon(Icons.place, size: 60.0, color: primaryColor),
              const SizedBox(height: 32.0),
              // Name
              Text(
                place.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 32.0),
              // Rating
              if (place.rating != null) ...[
                Text(
                  '${place.rating} ★',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
              // Categories
              Text(
                place.categories.join(', '),
                style: const TextStyle(fontSize: 18.0, color: Colors.black54),
              ),
              const SizedBox(height: 32.0),
              // Score
              Text(
                AppLocalizations.of(context).score + ': ${place.score}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 32.0),
              // Distance
              Text(
                AppLocalizations.of(context).distance +
                    ': ${place.distance.toStringAsFixed(2)}m',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 32.0),
              // Wheelchair
              Text(
                AppLocalizations.of(context).wheelchair +
                    ': ${place.wheelchair ?? "-"}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 32.0),
              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  if (state is RoutePlanning) {
                    return state.places.contains(place)
                        ? ElevatedButton(
                            onPressed: () {
                              context
                                  .read<RouteBloc>()
                                  .add(RemovePlaceFromRoute(place));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                            ),
                            child: Text(
                                AppLocalizations.of(context).removeFromRoute),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              context
                                  .read<RouteBloc>()
                                  .add(AddPlaceToRoute(place));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                            ),
                            child: Text(
                              AppLocalizations.of(context).addToRoute,
                            ),
                          );
                  } else if (state is RouteActive) {
                    if (place == state.getPlace()) {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<RouteBloc>().add(MoveToNextPlace());
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                        ),
                        child: Text(
                          AppLocalizations.of(context).completeVisit,
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  }

                  return const CircularProgressIndicator();
                },
              ),
              FutureBuilder(
                future: context.read<ReviewRepository>().getReviews(place),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        const Divider(),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 22.0),
                          title: Text(
                            AppLocalizations.of(context).reviews,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ReviewList(reviews: snapshot.data as List<Review>),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
