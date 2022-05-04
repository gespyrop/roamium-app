part of 'route_bloc.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object> get props => [];
}

class RouteLoading extends RouteState {}

class RoutePlanning extends RouteState {
  final List<Place> route;

  const RoutePlanning({required this.route});
}

class RouteActive extends RouteState {
  final List<Place> route;
  final int index;

  const RouteActive({required this.route, this.index = 0});

  Place getPlace() => route[index];
}

class RouteFinished extends RouteState {
  final List<Place> route;

  const RouteFinished({required this.route});
}
