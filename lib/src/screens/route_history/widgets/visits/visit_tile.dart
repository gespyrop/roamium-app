import 'package:flutter/material.dart';
import 'package:roamium_app/src/models/visit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/route_history/visit_details.dart';

class VisitTile extends StatelessWidget {
  final Visit visit;

  const VisitTile({Key? key, required this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(visit.name),
        subtitle: Text(
          visit.getTimestampString(
            locale: AppLocalizations.of(context).localeName,
          ),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VisitDetailsScreen(visit: visit),
          ),
        ),
      ),
    );
  }
}
