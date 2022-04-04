import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:roamium_app/src/models/user.dart';
import 'package:roamium_app/src/repositories/user/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc(this.userRepository) : super(AuthInitial()) {
    on<Login>((event, emit) async {
      emit(AuthLoading());
      try {
        User user = await userRepository.login(event.email, event.password);
        emit(AuthLoaded(user));
      } on AuthenticationException catch (e) {
        emit(AuthFailed(e.message));
      }
    });
  }
}
