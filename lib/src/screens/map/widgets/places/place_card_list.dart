import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/feature/feature_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/screens/map/widgets/places/place_card.dart';

class PlaceCardList extends StatelessWidget {
  final void Function(Place)? onPlaceCardTap;

  const PlaceCardList({Key? key, this.onPlaceCardTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeatureBloc, FeatureState>(
      builder: (context, state) {
        if (state is RecommendationsLoaded) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.places.length,
            itemBuilder: (context, index) {
              Place place = state.places[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: PlaceCard(
                  place: place,
                  onTap: onPlaceCardTap != null
                      ? () => onPlaceCardTap!(place)
                      : null,
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
