import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/repositories/directions/directions_repository.dart';

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

    on<ReorderPlace>((event, emit) {
      if (state is RoutePlanning) {
        List<Place> route = (state as RoutePlanning).route;
        emit(RouteLoading());

        // Get the new index
        int newIndex = event.newIndex;
        if (event.newIndex > event.oldIndex) newIndex--;

        Place place = route.removeAt(event.oldIndex);
        route.insert(newIndex, place);

        emit(RoutePlanning(route: route));
      }
    });

    on<StartRoute>((event, emit) {
      // TODO Remove debugging condition
      if (state is RouteActive) {
        emit(RoutePlanning(route: event.route));
      } else {
        emit(RouteActive(route: event.route));
      }
    });

    on<ResetRoute>((event, emit) => emit(const RoutePlanning(route: [])));

    on<MoveToNextPlace>((event, emit) {
      if (state is RouteActive) {
        RouteActive oldState = state as RouteActive;

        emit(RouteLoading());

        // If it is not the last place
        if (oldState.index + 1 < oldState.route.length) {
          emit(RouteActive(route: oldState.route, index: oldState.index + 1));
        } else {
          emit(RouteFinished(route: oldState.route));
        }
      }
    });
  }
}
