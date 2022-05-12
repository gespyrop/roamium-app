import 'package:flutter/material.dart' hide Route;
import 'package:roamium_app/src/models/visit.dart';
import 'package:roamium_app/src/screens/route_history/widgets/visits/visit_tile.dart';

class VisitList extends StatelessWidget {
  final List<Visit> visits;

  const VisitList({Key? key, required this.visits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: ((context, index) => VisitTile(visit: visits[index])),
        itemCount: visits.length,
      ),
    );
  }
}
