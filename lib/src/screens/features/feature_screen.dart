import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            const Text(
              "Let's plan your walk!",
              style: TextStyle(fontSize: 28.0, color: Colors.black54),
            ), // TODO Translate
            const SizedBox(height: 24.0),
            ListTile(
                title: const Text("Wheelchair"), // TODO Translate
                trailing: Switch(
                  value: wheelchair,
                  onChanged: (value) => setState(() => wheelchair = value),
                )),
            const Divider(),
            const ListTile(title: Text("Interests")),
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
                                selected: selectedCategories.contains(category),
                                onPressed: () {
                                  if (selectedCategories.contains(category)) {
                                    setState(() {
                                      selectedCategories.remove(category);
                                    });
                                  } else {
                                    setState(() {
                                      selectedCategories.add(category);
                                    });
                                  }
                                },
                              ),
                            )
                            .toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            ListTile(
              leading: InkWell(
                onTap: Navigator.of(context).pop,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: const Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
