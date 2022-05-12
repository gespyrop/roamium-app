import 'package:flutter/material.dart' hide Route;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/models/route.dart';
import 'package:roamium_app/src/screens/route_history/route_details.dart';

class RouteHistoryTile extends StatelessWidget {
  final Route route;

  const RouteHistoryTile({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          route.getTimestampString(
            locale: AppLocalizations.of(context).localeName,
          ),
        ),
        subtitle: Text(
          route.visits.map((v) => v.name).join(', '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RouteDetails(route: route)),
        ),
      ),
    );
  }
}
