import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if (state is RoutePlanning) {
          return SafeArea(
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
                      ReorderPlace(oldIndex: oldIndex, newIndex: newIndex),
                    );
              },
              itemBuilder: (context, index) {
                Place place = state.route[index];

                return RouteTile(
                  key: ValueKey(place),
                  place: place,
                  index: index,
                );
              },
              itemCount: state.route.length,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
