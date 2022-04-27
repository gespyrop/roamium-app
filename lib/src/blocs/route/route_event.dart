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
