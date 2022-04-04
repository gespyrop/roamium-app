part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final User user;

  AuthLoaded(this.user);
}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed(this.message);
}
