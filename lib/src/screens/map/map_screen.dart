import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/blocs/feature/feature_bloc.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/directions.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/repositories/directions/directions_repository.dart';
import 'package:roamium_app/src/repositories/route/route_repository.dart';
import 'package:roamium_app/src/screens/features/feature_screen.dart';
import 'package:roamium_app/src/screens/map/widgets/navigation/navigation_drawer.dart';
import 'package:roamium_app/src/screens/map/widgets/places/place_card_list.dart';
import 'package:roamium_app/src/screens/map/widgets/route/route_info_card.dart';
import 'package:roamium_app/src/screens/map/widgets/route/route_list.dart';
import 'package:roamium_app/src/screens/places/place_detail_screen.dart';
import 'package:roamium_app/src/theme/colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _completer = Completer();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final Location _location = Location();

  // Map
  GoogleMapController? _controller;
  LocationData? location;
  String? _mapStyle;

  // Markers
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Place? _selectedPlace;

  // Polylines
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  // Directions
  Directions? _directions;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.97945, 23.71622),
    zoom: 7,
  );

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map/style.json').then((jsonStyle) {
      setState(() => _mapStyle = jsonStyle);
    });
  }

  // Errors

  /// Shows an error snackbar with the given `message`.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // Navigation

  /// Launches the feature screen.
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

  /// Launches the `place`'s detail screen.
  void _launchPlaceDetailScreen(Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)),
    );
  }

  // Markers

  /// Creates a marker for the given `place`.
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
      onTap: () => _selectPlace(place),
    );

    return marker;
  }

  /// Adds markers for a list of `places` on the map.
  void _addMarkers(List<Place> places, {double alpha = 0.1}) {
    // Create new markers
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

    for (Place place in places) {
      Marker marker = _createMarker(place, alpha: alpha);
      markers[marker.markerId] = marker;
    }

    // Unselect the selected place
    if (_selectedPlace != null) {
      Marker marker = _createMarker(_selectedPlace!);

      if (_markers.containsKey(marker.markerId)) {
        _controller!.hideMarkerInfoWindow(marker.markerId);
      }

      setState(() => _selectedPlace = null);
    }

    // Set the new markers
    setState(() => _markers = markers);
  }

  // Polylines

  /// Creates a Polyline to be drawn on the map
  /// using a list of `polylineCoordinates`.
  Polyline _createPolyline(List<PointLatLng> polylineCoordinates) {
    List<LatLng> points = polylineCoordinates
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    PolylineId polylineId = PolylineId(_polylines.length.toString());

    return Polyline(
      polylineId: polylineId,
      color: primaryColor,
      width: 4,
      points: points,
    );
  }

  // Places

  /// Selects a `place`'s marker on the map.
  Marker _selectPlace(Place place) {
    Marker marker = _createMarker(place);

    if (_selectedPlace != place) {
      setState(() {
        // Select the new marker
        _markers[marker.markerId] = marker;

        // Deselect the previous marker
        if (_selectedPlace != null &&
            context.read<RouteBloc>().state is RoutePlanning) {
          Marker previousMarker = _createMarker(_selectedPlace!, alpha: 0.1);
          _markers[previousMarker.markerId] = previousMarker;
        }

        _selectedPlace = place;
      });
    }

    return marker;
  }

  /// Focuses on a `place` and shows the marker's info window.
  void _focusPlace(Place place) {
    Marker marker = _selectPlace(place);

    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(place.latitude, place.longitude),
          zoom: 16,
        ),
      ),
    );

    // Focus on the marker and show the info window
    _controller!.showMarkerInfoWindow(marker.markerId);
  }

  // General map utils

  /// Clears Markers and Polylines from the map
  void _clearMapElements() {
    setState(() {
      _markers = {};
      _polylines = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Roamium'),
        actions: [
          IconButton(
            onPressed: _launchFeatureScreen,
            icon: const Icon(Icons.filter_alt),
          ),
          IconButton(
            onPressed: _key.currentState?.openEndDrawer,
            icon: const Icon(Icons.route_outlined),
          )
        ],
      ),
      drawer: const NavigationDrawer(),
      endDrawer: const Drawer(child: RouteList()),
      body: BlocListener<FeatureBloc, FeatureState>(
        listener: (context, state) {
          if (state is RecommendationsLoaded) {
            _clearMapElements();
            _addMarkers(state.places);
          } else if (state is RecommendationsFailed) {
            _showErrorSnackBar(state.message);
          }
        },
        child: BlocListener<RouteBloc, RouteState>(
          listener: (context, state) async {
            if (state is RouteActive && location != null) {
              _focusPlace(state.getPlace());

              if (state.index == 0) {
                // Reset directions
                setState(() => _directions = null);

                // Add markers for route places
                _clearMapElements();
                _addMarkers(state.route.places, alpha: 1);

                Directions directions = await context
                    .read<DirectionsRepository>()
                    .getDirections(
                        location: location!, route: state.route.places);

                Polyline polyline =
                    _createPolyline(directions.polylineCoordinates);

                setState(() {
                  _polylines[polyline.polylineId] = polyline;
                  _directions = directions;
                });
              }
            } else if (state is RouteFinished) {
              _clearMapElements();
              // TODO Open route summary page
              context.read<RouteBloc>().add(ResetRoute());
              context.read<FeatureBloc>().add(ResetFeatures());
            } else if (state is RouteFailure) {
              switch (state.exception.runtimeType) {
                case RouteCreationException:
                  _showErrorSnackBar(
                      AppLocalizations.of(context).routeCreationError);
                  break;
                case VisitException:
                  _showErrorSnackBar(AppLocalizations.of(context).visitError);
                  break;
                case RouteCompletionException:
                  _showErrorSnackBar(
                      AppLocalizations.of(context).routeCompletionError);
                  {}
              }
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
                  polylines: Set<Polyline>.of(_polylines.values),
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

              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  height: 120.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
                    child: BlocBuilder<RouteBloc, RouteState>(
                      builder: (context, state) {
                        if (state is RoutePlanning) {
                          // Horizontal card list
                          return PlaceCardList(
                            onPlaceCardTap: _focusPlace,
                          );
                        } else if (state is RouteActive &&
                            _directions != null) {
                          // Route info summary
                          return RouteInfoCard(
                            directions: _directions!,
                            place: state.getPlace(),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
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
      ),
    );
  }
}
