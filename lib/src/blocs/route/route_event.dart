part of 'route_bloc.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

class AddPlaceToRoute extends RouteEvent {
  final Place place;

  const AddPlaceToRoute(this.place);
}

class RemovePlaceFromRoute extends RouteEvent {
  final Place place;

  const RemovePlaceFromRoute(this.place);
}

class ReorderPlace extends RouteEvent {
  final int oldIndex, newIndex;

  const ReorderPlace({required this.oldIndex, required this.newIndex});
}

class StartRoute extends RouteEvent {
  final List<Place> places;

  const StartRoute(this.places);
}

class FinishRoute extends RouteEvent {
  final Route route;

  const FinishRoute(this.route);
}

class ResetRoute extends RouteEvent {}

class MoveToNextPlace extends RouteEvent {}
