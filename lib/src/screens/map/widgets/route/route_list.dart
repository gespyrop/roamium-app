import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/screens/map/widgets/route/route_tile.dart';

class RouteList extends StatelessWidget {
  const RouteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteBloc, RouteState>(
      builder: (context, state) {
        if (state is RoutePlanning) {
          return ListView.builder(
            itemBuilder: (context, index) =>
                RouteTile(place: state.route[index]),
            itemCount: state.route.length,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
