import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/blocs/feature/feature_bloc.dart';
import 'package:roamium_app/src/models/category.dart';
import 'package:roamium_app/src/repositories/place/place_repository.dart';
import 'package:roamium_app/src/screens/features/widgets/category_button.dart';
import 'package:roamium_app/src/theme/colors.dart';
import 'package:roamium_app/src/widgets/logo.dart';

class FeatureScreen extends StatefulWidget {
  final double longitude, latitude;
  const FeatureScreen({
    Key? key,
    required this.longitude,
    required this.latitude,
  }) : super(key: key);

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  bool wheelchair = false;
  List<Category> selectedCategories = [];

  void _submitFeatures() {
    context.read<FeatureBloc>().add(
          SubmitFeatures(
            widget.longitude,
            widget.latitude,
            categories: selectedCategories,
            wheelchair: wheelchair,
          ),
        );

    Navigator.of(context).pop();
  }

  void _skipFeatures() {
    context.read<FeatureBloc>().add(SkipFeatures());

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24.0),
            const RoamiumLogo(),
            const SizedBox(height: 24.0),
            Text(
              AppLocalizations.of(context).planWalk,
              style: const TextStyle(fontSize: 28.0, color: Colors.black54),
            ),
            const SizedBox(height: 24.0),
            ListTile(
                title: Text(AppLocalizations.of(context).wheelchair),
                trailing: Switch(
                  value: wheelchair,
                  onChanged: (value) => setState(() => wheelchair = value),
                )),
            const Divider(),
            ListTile(title: Text(AppLocalizations.of(context).interests)),
            Expanded(
              child: FutureBuilder(
                future: context.read<PlaceRepository>().getNearbyCategories(
                      longitude: widget.longitude,
                      latitude: widget.latitude,
                    ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Category> categories = snapshot.data as List<Category>;

                    return SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        runSpacing: 8.0,
                        children: categories
                            .map(
                              (category) => CategoryButton(
                                category: category,
                                onPressed: () {
                                  // Not calling setState to avoid rebuilding
                                  if (selectedCategories.contains(category)) {
                                    selectedCategories.remove(category);
                                  } else {
                                    selectedCategories.add(category);
                                  }
                                },
                              ),
                            )
                            .toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong...'));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            ListTile(
              leading: InkWell(
                onTap: _skipFeatures,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Text(
                    AppLocalizations.of(context).skip,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              trailing: ElevatedButton(
                onPressed: _submitFeatures,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).submit,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
