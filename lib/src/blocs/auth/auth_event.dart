part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckToken extends AuthEvent {}

class Login extends AuthEvent {
  final String email, password;

  Login(this.email, this.password);
}

class Logout extends AuthEvent {}
