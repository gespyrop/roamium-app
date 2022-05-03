import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/feature/feature_bloc.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/screens/map/widgets/route/route_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RouteList extends StatelessWidget {
  const RouteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteBloc, RouteState>(
      builder: (context, state) {
        List<Place>? route;

        if (state is RoutePlanning) {
          route = state.route;
        } else if (state is RouteActive) {
          route = state.route;
        }

        if (route != null) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ReorderableListView.builder(
                    header: ListTile(
                      title: Text(
                        AppLocalizations.of(context).myRoute,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    onReorder: (oldIndex, newIndex) {
                      context.read<RouteBloc>().add(
                            ReorderPlace(
                                oldIndex: oldIndex, newIndex: newIndex),
                          );
                    },
                    itemBuilder: (context, index) {
                      Place place = route![index];

                      return RouteTile(
                        key: ValueKey(place),
                        place: place,
                        index: index,
                      );
                    },
                    itemCount: route.length,
                  ),
                ),
                if (state is RoutePlanning)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        child: const Text(
                          "Start",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        // Start the route
                        onPressed: () {
                          context.read<RouteBloc>().add(StartRoute(route!));
                          Navigator.of(context).pop();
                        }),
                  )
                else if (state is RouteActive)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        child: const Text(
                          "Stop",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onPressed: () {
                          context.read<RouteBloc>().add(StartRoute(route!));
                          context
                              .read<FeatureBloc>()
                              .add(ReloadRecommendations());
                          Navigator.of(context).pop();
                        }),
                  )
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
