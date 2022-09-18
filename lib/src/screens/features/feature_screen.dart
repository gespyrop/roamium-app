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
  String query = '';

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

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
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 24.0),
                          const RoamiumLogo(),
                          const SizedBox(height: 24.0),
                          Text(
                            AppLocalizations.of(context).planWalk,
                            style: const TextStyle(
                                fontSize: 28.0, color: Colors.black54),
                          ),
                          const SizedBox(height: 24.0),
                          ListTile(
                            title:
                                Text(AppLocalizations.of(context).wheelchair),
                            trailing: Switch(
                              value: wheelchair,
                              onChanged: (value) =>
                                  setState(() => wheelchair = value),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ];
                },
                body: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).interests,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => setState(() => query = value),
                            style: const TextStyle(
                                color: primaryColor, fontSize: 14),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: query.isNotEmpty
                                  ? IconButton(
                                      color: Colors.black54,
                                      iconSize: 16,
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => query = '');
                                      },
                                      icon: const Icon(Icons.clear),
                                    )
                                  : null,
                              hintText:
                                  AppLocalizations.of(context).searchInterests,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: FutureBuilder(
                    future: context.read<PlaceRepository>().getNearbyCategories(
                          longitude: widget.longitude,
                          latitude: widget.latitude,
                        ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Category> categories =
                            snapshot.data as List<Category>;
                        return SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              runSpacing: 8.0,
                              children: categories
                                  .map(
                                    (category) => category.name
                                            .toLowerCase()
                                            .contains(query.toLowerCase())
                                        ? CategoryButton(
                                            category: category,
                                            selected: selectedCategories
                                                .contains(category),
                                            onPressed: () {
                                              // Not calling setState to avoid rebuilding
                                              if (selectedCategories
                                                  .contains(category)) {
                                                selectedCategories
                                                    .remove(category);
                                              } else {
                                                selectedCategories
                                                    .add(category);
                                              }
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              AppLocalizations.of(context).somethingWentWrong),
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
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
