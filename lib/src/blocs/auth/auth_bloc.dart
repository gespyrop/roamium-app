import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:roamium_app/src/models/user.dart';
import 'package:roamium_app/src/repositories/user/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc(this.userRepository) : super(AuthInitial()) {
    on<CheckToken>((event, emit) async {
      emit(AuthLoading());
      try {
        User? user = await userRepository.loginFromStoredToken();
        emit(user != null ? AuthLoaded(user) : AuthInitial());
      } on AuthenticationException {
        emit(AuthInitial());
      } on DioError {
        emit(AuthInitial());
      }
    });

    on<Login>((event, emit) async {
      emit(AuthLoading());
      try {
        User user = await userRepository.login(event.email, event.password);
        emit(AuthLoaded(user));
      } on AuthenticationException catch (e) {
        emit(AuthFailed(e.message));
      }
    });

    on<Logout>((event, emit) async {
      emit(AuthLoading());
      await userRepository.logout();
      emit(AuthInitial());
    });
  }
}
