import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/models/review.dart';
import 'package:roamium_app/src/models/visit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/repositories/reviews/review_repository.dart';
import 'package:roamium_app/src/screens/route_history/widgets/reviews/review_form.dart';
import 'package:roamium_app/src/theme/colors.dart';

class VisitDetailsScreen extends StatelessWidget {
  final Visit visit;

  const VisitDetailsScreen({Key? key, required this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(visit.name)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  visit.name,
                  style: const TextStyle(
                    fontSize: 28.0,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                visit.timestamp?.weekday == DateTime.saturday
                    ? AppLocalizations.of(context).onSat
                    : AppLocalizations.of(context).on +
                        visit.getTimestampString(
                          locale: AppLocalizations.of(context).localeName,
                        ),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              FutureBuilder(
                future: context.read<ReviewRepository>().getReview(visit),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ReviewForm(
                      visit: visit,
                      review: snapshot.data as Review,
                    );
                  } else if (snapshot.hasError) {
                    return ReviewForm(visit: visit);
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
