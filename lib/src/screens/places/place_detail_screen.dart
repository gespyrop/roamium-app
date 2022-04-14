import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/models/place.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.place, size: 60.0, color: primaryColor),
            // Name
            Text(
              place.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            // Categories
            Text(
              place.categories.join(', '),
              style: const TextStyle(fontSize: 18.0, color: Colors.black54),
            ),
            // Score
            Text(
              AppLocalizations.of(context).score + ': ${place.score}',
              style: const TextStyle(fontSize: 16.0),
            ),
            // Distance
            Text(
              AppLocalizations.of(context).distance +
                  ': ${place.distance.toStringAsFixed(2)}m',
              style: const TextStyle(fontSize: 16.0),
            ),
            // Wheelchair
            Text(
              AppLocalizations.of(context).wheelchair +
                  ': ${place.wheelchair ?? "-"}',
              style: const TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
