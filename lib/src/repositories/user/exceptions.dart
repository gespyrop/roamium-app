part of 'user_repository.dart';

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({this.message = 'Unknown error occurred'});
}

class RegistrationException implements Exception {
  final String message;

  RegistrationException({this.message = 'Unknown registration error'});
}
