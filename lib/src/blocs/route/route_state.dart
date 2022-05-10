part of 'route_bloc.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];
}

class RouteLoading extends RouteState {}

class RouteFailure extends RouteState {
  final Exception exception;

  const RouteFailure(this.exception);
}

class RoutePlanning extends RouteState {
  final List<Place> places;

  const RoutePlanning({required this.places});
}

class RouteActive extends RouteState {
  final Route route;
  final int index;

  const RouteActive({required this.route, this.index = 0});

  Place getPlace() => route.places[index];
}

class RouteFinished extends RouteState {
  final Route route;

  const RouteFinished({required this.route});
}
