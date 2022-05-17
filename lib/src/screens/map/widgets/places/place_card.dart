import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/theme/colors.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;
  const PlaceCard({Key? key, required this.place, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.0,
      child: GestureDetector(
        onTap: onTap,
        child: BlocBuilder<RouteBloc, RouteState>(
          builder: (context, state) {
            if (state is RoutePlanning) {
              // Check if the place has been selected for the current route
              bool selected = state.places.contains(place);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: selected
                      ? const BorderSide(width: 2, color: primaryColor)
                      : BorderSide.none,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Score: ${place.score?.toStringAsFixed(6)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (place.rating != null)
                          Text(
                            '${place.rating} ★',
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              place.categories.join(", "),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            onPressed: () {
                              if (selected) {
                                context
                                    .read<RouteBloc>()
                                    .add(RemovePlaceFromRoute(place));
                              } else {
                                context
                                    .read<RouteBloc>()
                                    .add(AddPlaceToRoute(place));

                                if (onTap != null) onTap!();
                              }
                            },
                            color: primaryColor,
                            icon: Icon(
                              selected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
