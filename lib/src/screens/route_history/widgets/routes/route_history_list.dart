import 'package:flutter/material.dart' hide Route;
import 'package:roamium_app/src/models/route.dart';
import 'package:roamium_app/src/screens/route_history/widgets/routes/route_history_tile.dart';

class RouteHistoryList extends StatelessWidget {
  final List<Route> routes;

  const RouteHistoryList({Key? key, required this.routes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) => RouteHistoryTile(route: routes[index]),
        itemCount: routes.length,
      ),
    );
  }
}
