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

  RouteBloc(this.routeRepository) : super(const RoutePlanning(places: [])) {
    on<AddPlaceToRoute>((event, emit) {
      if (state is RoutePlanning) {
        List<Place> places = List.from((state as RoutePlanning).places);
        emit(RouteLoading());
        places.add(event.place);
        emit(RoutePlanning(places: places));
      }
    });

    on<RemovePlaceFromRoute>((event, emit) {
      if (state is RoutePlanning) {
        List<Place> places = (state as RoutePlanning).places;
        emit(RouteLoading());
        places.remove(event.place);
        emit(RoutePlanning(places: places));
      }
    });

    on<ReorderPlace>((event, emit) {
      if (state is RoutePlanning) {
        List<Place> places = (state as RoutePlanning).places;
        emit(RouteLoading());

        // Get the new index
        int newIndex = event.newIndex;
        if (event.newIndex > event.oldIndex) newIndex--;

        Place place = places.removeAt(event.oldIndex);
        places.insert(newIndex, place);

        emit(RoutePlanning(places: places));
      }
    });

    on<StartRoute>((event, emit) async {
      RouteState oldState = state;
      emit(RouteLoading());

      try {
        Route route = await routeRepository.createRoute(
          event.places,
          routeType: event.routeType,
        );

        emit(RouteActive(route: route));
      } on RouteCreationException catch (e) {
        emit(RouteFailure(e));
        Future.delayed(const Duration(milliseconds: 100));
        emit(oldState);
      }
    });

    on<FinishRoute>((event, emit) async {
      RouteState oldState = state;
      emit(RouteLoading());

      try {
        Route route = await routeRepository.completeRoute(event.route);
        emit(RouteFinished(route: route));
      } on RouteCompletionException catch (e) {
        emit(RouteFailure(e));
        Future.delayed(const Duration(milliseconds: 100));
        emit(oldState);
      } on EmptyRouteException {
        emit(RouteFinished(route: event.route));
      }
    });

    on<ResetRoute>((event, emit) => emit(const RoutePlanning(places: [])));

    on<MoveToNextPlace>((event, emit) async {
      if (state is RouteActive) {
        RouteActive oldState = state as RouteActive;
        emit(RouteLoading());

        try {
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
        } on VisitException catch (e) {
          emit(RouteFailure(e));
          Future.delayed(const Duration(milliseconds: 100));
          emit(oldState);
        } on RouteCompletionException catch (e) {
          emit(RouteFailure(e));
          Future.delayed(const Duration(milliseconds: 100));
          emit(oldState);
        }
      }
    });
  }
}
