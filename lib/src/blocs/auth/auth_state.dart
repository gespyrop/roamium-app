part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

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
