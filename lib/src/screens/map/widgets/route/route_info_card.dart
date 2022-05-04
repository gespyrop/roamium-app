import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/directions.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RouteInfoCard extends StatelessWidget {
  final Directions directions;
  final Place place;

  const RouteInfoCard({Key? key, required this.directions, required this.place})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: ListTile(
          title: Text(
            AppLocalizations.of(context).next + ': ${place.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place.categories.join(", ")),
              const Divider(),
              Text(
                AppLocalizations.of(context).duration +
                    ': ${directions.durationMinutes} ' +
                    AppLocalizations.of(context).minutes,
              ),
              Text(AppLocalizations.of(context).distance +
                  ': ${directions.distance.toString()} km'),
            ],
          ),
          trailing: IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.topRight,
            icon: const Icon(Icons.next_plan),
            color: primaryColor,
            // Move to the next place
            onPressed: () => context.read<RouteBloc>().add(MoveToNextPlace()),
          ),
        ),
      ),
    );
  }
}
