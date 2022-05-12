import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roamium_app/src/repositories/route/route_repository.dart';
import 'package:roamium_app/src/models/route.dart';
import 'package:roamium_app/src/screens/route_history/widgets/list_header.dart';
import 'package:roamium_app/src/screens/route_history/widgets/routes/route_history_list.dart';

class RouteHistoryScreen extends StatelessWidget {
  const RouteHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).routeHistory),
        elevation: 2,
      ),
      body: Center(
        child: FutureBuilder(
          future: context.read<RouteRepository>().getRoutes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  ListHeader(text: AppLocalizations.of(context).routes),
                  Expanded(
                    child: RouteHistoryList(
                      routes: snapshot.data as List<Route>,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(AppLocalizations.of(context).getRoutesError);
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
