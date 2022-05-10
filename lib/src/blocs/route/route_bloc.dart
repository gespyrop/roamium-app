import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roamium_app/src/models/place.dart';
import 'package:roamium_app/src/models/route.dart';
import 'package:roamium_app/src/models/visit.dart';
import 'package:roamium_app/src/repositories/route/route_repository.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final RouteRepository routeRepository;

  RouteBloc(this.routeRepository) : super(const RoutePlanning(route: [])) {
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

    on<StartRoute>((event, emit) async {
      Route route = await routeRepository.createRoute(event.places);

      emit(RouteActive(route: route));
    });

    on<FinishRoute>((event, emit) async {
      Route route = await routeRepository.completeRoute(event.route);
      emit(RouteFinished(route: route));
    });

    on<ResetRoute>((event, emit) => emit(const RoutePlanning(route: [])));

    on<MoveToNextPlace>((event, emit) async {
      if (state is RouteActive) {
        RouteActive oldState = state as RouteActive;

        emit(RouteLoading());

        // Create a visit
        Visit visit = await routeRepository.visitPlace(
          oldState.route,
          oldState.getPlace(),
        );

        // Add the new visit to the route
        List<Visit> visits = List.from(oldState.route.visits)..add(visit);
        Route route = Route.copyWithVisits(oldState.route, visits);

        // Move to the next place
        if (oldState.index + 1 < oldState.route.places.length) {
          // If it is not the last place the route is still active
          emit(RouteActive(route: route, index: oldState.index + 1));
        } else {
          Route finishedRoute = await routeRepository.completeRoute(route);
          emit(RouteFinished(route: finishedRoute));
        }
      }
    });
  }
}
