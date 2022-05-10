import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:roamium_app/src/blocs/route/route_bloc.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/screens/places/place_detail_screen.dart';

class RouteTile extends StatelessWidget {
  final Place place;
  final int index;

  const RouteTile({
    Key? key,
    required this.place,
    required this.index,
  }) : super(key: key);

  void _deletePlace(BuildContext context) {
    context.read<RouteBloc>().add(RemovePlaceFromRoute(place));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: _deletePlace,
            backgroundColor: Colors.redAccent,
            icon: Icons.delete,
          )
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlaceDetailScreen(place: place),
            ),
          );
        },
        leading: BlocBuilder<RouteBloc, RouteState>(
          builder: (context, state) {
            return (state is RouteActive && state.route.isVisited(place))
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  );
          },
        ),
        title: Text(place.name),
      ),
    );
  }
}
