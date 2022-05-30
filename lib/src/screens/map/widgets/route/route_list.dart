import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/route.dart';
import 'package:roamium_app/src/screens/map/widgets/route/route_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/map/widgets/route/route_type_selector.dart';

class RouteList extends StatefulWidget {
  const RouteList({Key? key}) : super(key: key);

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  RouteType routeType = RouteType.walking;

  Widget _buildListHeader(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context).myRoute,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteBloc, RouteState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Planning the route
              if (state is RoutePlanning) ...[
                Expanded(
                  child: ReorderableListView.builder(
                    header: _buildListHeader(context),
                    onReorder: (oldIndex, newIndex) {
                      context.read<RouteBloc>().add(
                            ReorderPlace(
                                oldIndex: oldIndex, newIndex: newIndex),
                          );
                    },
                    itemBuilder: (context, index) {
                      Place place = state.places[index];

                      return RouteTile(
                        key: ValueKey(place),
                        place: place,
                        index: index,
                      );
                    },
                    itemCount: state.places.length,
                  ),
                ),
                if (state.places.isNotEmpty)
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RouteTypeSelector(
                          onChanged: (rt) {
                            if (rt != null) {
                              setState(() => routeType = rt);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              child: Text(
                                AppLocalizations.of(context).startRoute,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              onPressed: () {
                                // Start the route
                                context.read<RouteBloc>().add(
                                      StartRoute(
                                        state.places,
                                        routeType: routeType,
                                      ),
                                    );

                                // Close the drawer
                                Navigator.of(context).pop();
                              }),
                        ),
                      ],
                    ),
                  ),
              ]

              // The route is active
              else if (state is RouteActive &&
                  state.route.places.isNotEmpty) ...[
                _buildListHeader(context),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      Place place = state.route.places[index];

                      return RouteTile(
                        key: ValueKey(place),
                        place: place,
                        index: index,
                      );
                    },
                    itemCount: state.route.places.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context).finishRoute,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      onPressed: () {
                        // Finish the route
                        context.read<RouteBloc>().add(FinishRoute(state.route));

                        // Close the drawer
                        Navigator.of(context).pop();
                      }),
                )
              ] else
                _buildListHeader(context)
            ],
          ),
        );
      },
    );
  }
}
