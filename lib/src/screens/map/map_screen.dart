import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  // bool firstBuild = true;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.97945, 23.71622),
    zoom: 15,
  );

  void _openFeatureScreen() async {
    if (location?.longitude != null && location?.latitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeatureScreen(
            longitude: location!.longitude!,
            latitude: location!.latitude!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          _location.onLocationChanged.listen((l) {
            if (location == null) {
              setState(() => location = l);
              _openFeatureScreen();
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(l.latitude!, l.longitude!),
                    zoom: 15,
                  ),
                ),
              );
            } else {
              setState(() => location = l);
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.filter_alt),
        onPressed: _openFeatureScreen,
      ),
    );
  }
}
