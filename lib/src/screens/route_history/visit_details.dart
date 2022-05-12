import 'package:flutter/material.dart';
import 'package:roamium_app/src/models/visit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/theme/colors.dart';

class VisitDetailsScreen extends StatelessWidget {
  final Visit visit;

  const VisitDetailsScreen({Key? key, required this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(visit.name)),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            Text(
              AppLocalizations.of(context).youVisited,
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                visit.name,
                style: const TextStyle(
                  fontSize: 32.0,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              visit.timestamp?.weekday == DateTime.saturday
                  ? AppLocalizations.of(context).on
                  : AppLocalizations.of(context).onSat +
                      visit.getTimestampString(
                        locale: AppLocalizations.of(context).localeName,
                      ),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
