import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/screens/places/place_detail_screen.dart';

class RouteTile extends StatelessWidget {
  final Place place;

  const RouteTile({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlaceDetailScreen(place: place),
            ),
          );
        },
        title: Text(place.name),
        // leading: const Icon(Icons.drag_handle),
        trailing: IconButton(
          onPressed: () =>
              context.read<RouteBloc>().add(RemovePlaceFromRoute(place)),
          icon: const Icon(
            Icons.delete, // TODO Swipe to delete
            color: Colors.redAccent,
          ),
        ));
  }
}
