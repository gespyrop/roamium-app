import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roamium_app/src/models/place.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc() : super(const RoutePlanning(route: [])) {
    on<AddPlaceToRoute>((event, emit) {
      if (state is RoutePlanning) {
        List<Place> route = List.from((state as RoutePlanning).route);
        emit(RouteLoading());
        route.add(event.place);
        emit(RoutePlanning(route: route));
      }
    });

    on<RemovePlaceFromRoute>((event, emit) {
      if (state is RoutePlanning) {
        List<Place> route = (state as RoutePlanning).route;
        emit(RouteLoading());
        route.remove(event.place);
        emit(RoutePlanning(route: route));
      }
    });
  }
}
