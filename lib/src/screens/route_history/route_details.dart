import 'package:flutter/material.dart' hide Route;
import 'package:roamium_app/src/models/route.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/screens/route_history/widgets/list_header.dart';
import 'package:roamium_app/src/screens/route_history/widgets/visits/visit_list.dart';

class RouteDetails extends StatelessWidget {
  final Route route;

  const RouteDetails({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).routeDetails),
        elevation: 2,
      ),
      body: Column(
        children: [
          ListHeader(text: AppLocalizations.of(context).visits),
          Expanded(child: VisitList(visits: route.visits)),
        ],
      ),
    );
  }
}
