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
