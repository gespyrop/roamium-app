import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:roamium_app/src/blocs/feature/feature_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/screens/features/feature_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location _location = Location();
  LocationData? location;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.97945, 23.71622),
    zoom: 15,
  );

  void _openFeatureScreen() async {
    if (location?.longitude != null && location?.latitude != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FeatureScreen(
            longitude: location!.longitude!,
            latitude: location!.latitude!,
          ),
        ),
      );
    }
  }

  void _addMarker(Place place) {
    MarkerId markerId = MarkerId(place.id.toString());

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(place.latitude, place.longitude),
      infoWindow: InfoWindow(title: place.name, snippet: place.summary),
      onTap: () {},
    );

    setState(() => markers[markerId] = marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FeatureBloc, FeatureState>(
        listener: (context, state) {
          if (state is RecommendationsLoaded) {
            for (Place place in state.places) {
              _addMarker(place);
            }
          } else if (state is RecommendationsFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);

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
                _openFeatureScreen();
              } else {
                location = l;
              }
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.filter_alt),
        onPressed: _openFeatureScreen,
      ),
    );
  }
}
