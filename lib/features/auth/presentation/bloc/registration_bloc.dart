

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place_finder_app/features/auth/presentation/bloc/registration_event.dart';
import 'package:place_finder_app/features/auth/presentation/bloc/registration_state.dart';

import '../../../../core/data_sources/data_state.dart';
import '../../domain/usecase/register_user_usecase.dart';


class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase registerUserUseCase;

  RegisterBloc(this.registerUserUseCase) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());

    final result = await registerUserUseCase(params: event.user);

    if (result is DataSuccess) {
      emit(RegisterSuccess());
    } else if (result is DataFailure) {
      emit(RegisterFailure(result.error ?? "Registration failed"));
    }
  }
}
