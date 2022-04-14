import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/blocs/feature/feature_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/screens/features/feature_screen.dart';
import 'package:roamium_app/src/screens/map/widgets/place_card_list.dart';
import 'package:roamium_app/src/screens/places/place_detail_screen.dart';
import 'package:roamium_app/src/theme/colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _completer = Completer();
  final Location _location = Location();

  // Map
  GoogleMapController? _controller;
  LocationData? location;
  String? _mapStyle;

  // Markers
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.97945, 23.71622),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map/style.json').then((jsonStyle) {
      setState(() => _mapStyle = jsonStyle);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _launchFeatureScreen() async {
    if (location?.longitude != null && location?.latitude != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FeatureScreen(
            longitude: location!.longitude!,
            latitude: location!.latitude!,
          ),
        ),
      );
    } else {
      _showErrorSnackBar(
        AppLocalizations.of(context).locationRequired,
      );
    }
  }

  void _launchPlaceDetailScreen(Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)),
    );
  }

  Marker _createMarker(Place place, {double alpha = 1.0}) {
    MarkerId markerId = MarkerId(place.id.toString());

    final Marker marker = Marker(
      markerId: markerId,
      alpha: alpha,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(place.latitude, place.longitude),
      infoWindow: InfoWindow(
        title: place.name,
        snippet: place.summary,
        onTap: () => _launchPlaceDetailScreen(place),
      ),
      onTap: () {
        setState(() {
          // Select the new marker
          _markers[markerId] = _createMarker(place);
        });
      },
    );

    return marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roamium'),
        actions: [
          IconButton(
            onPressed: _launchFeatureScreen,
            icon: const Icon(Icons.filter_alt),
          )
        ],
      ),
      body: BlocListener<FeatureBloc, FeatureState>(
        listener: (context, state) {
          if (state is RecommendationsLoaded) {
            // Clear previous markers
            setState(() => _markers = {});

            // Create new markers
            Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

            for (Place place in state.places) {
              Marker marker = _createMarker(place, alpha: 0.1);
              markers[marker.markerId] = marker;
            }

            // Set the new markers
            setState(() => _markers = markers);
          } else if (state is RecommendationsFailed) {
            _showErrorSnackBar(state.message);
          }
        },
        child: Stack(
          children: [
            // Map
            if (_mapStyle != null)
              GoogleMap(
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(_markers.values),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);
                  _completer.complete(controller);
                  _controller = controller;

                  _location.onLocationChanged.listen((l) {
                    if (location == null) {
                      location = l;
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(l.latitude!, l.longitude!),
                            zoom: 15,
                          ),
                        ),
                      );
                      _launchFeatureScreen();
                    } else {
                      location = l;
                    }
                  });
                },
              ),

            // Horizontal card list
            PlaceCardList(
              onPlaceCardTap: (Place place) async {
                // Select the new marker
                Marker marker = _createMarker(place);
                setState(() => _markers[marker.markerId] = marker);

                // Focus on the marker and show the info window
                _controller!.showMarkerInfoWindow(marker.markerId);

                _controller!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(place.latitude, place.longitude),
                      zoom: 16,
                    ),
                  ),
                );
              },
            ),

            // Loading recommendations
            BlocBuilder<FeatureBloc, FeatureState>(
              builder: (context, state) {
                if (state is RecommendationsLoading) {
                  return Container(
                    color: primaryColor.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
