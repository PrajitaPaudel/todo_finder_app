import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/local_storage.dart';
import '../../domain/usecase/login_user_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUserUseCase loginUserUseCase;

  LoginBloc(this.loginUserUseCase) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await loginUserUseCase(params: event.user);

    if (result.error == null) {
      await LocalStorage.setString('user_email', result.data!.email);
      if (result.data!.name != null) {
        await LocalStorage.setString('user_name', result.data!.name!);
      }
      await LocalStorage.setBool('is_logged_in', true);
      await LocalStorage.setBool('is_registered', true);
      emit(LoginSuccess(result.data!));
    } else {
      emit(LoginFailure(result.error!));
    }
  }
}
