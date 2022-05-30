part of 'route_repository.dart';

/// Thrown when the route creation fails in the backend.
class RouteCreationException implements Exception {}

/// Thrown when a place visit fails to be submitted.
class VisitException implements Exception {}

/// Thrown when the route fails to be marked as completed.
class RouteCompletionException implements Exception {}

/// Thrown when an empty route gets completed.
class EmptyRouteException implements Exception {}
