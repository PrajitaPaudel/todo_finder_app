import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data_sources/data_state.dart';
import '../../domain/entity/profile_entity.dart';
import '../../../auth/domain/usecase/logout_usecase.dart';
import '../../domain/usecase/update_display_name_usecase.dart';
import '../../domain/usecase/watch_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final WatchProfileUseCase watchProfileUseCase;
  final UpdateDisplayNameUseCase updateDisplayNameUseCase;
  final LogoutUseCase logoutUseCase;

  StreamSubscription<ProfileEntity>? _profileSubscription;

  ProfileBloc(
    this.watchProfileUseCase,
    this.updateDisplayNameUseCase,
    this.logoutUseCase,
  ) : super(ProfileInitial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileDisplayNameSubmitted>(_onDisplayNameSubmitted);
    on<ProfileLogoutRequested>(_onLogoutRequested);
    on<ProfileChanged>(_onProfileChanged);
    on<ProfileErrorOccurred>(_onProfileErrorOccurred);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    await _profileSubscription?.cancel();

    try {
      final stream = await watchProfileUseCase();
      _profileSubscription = stream.listen(
        (profile) => add(ProfileChanged(profile)),
        onError: (error, stackTrace) {
          addError(error, stackTrace);
          add(ProfileErrorOccurred(error.toString()));
        },
      );
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onProfileChanged(
    ProfileChanged event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoaded(event.profile));
  }

  Future<void> _onProfileErrorOccurred(
    ProfileErrorOccurred event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileFailure(event.message));
  }

  Future<void> _onLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await _profileSubscription?.cancel();
    final result = await logoutUseCase();
    if (result is DataSuccess) {
      emit(ProfileLogoutSuccess());
    } else if (result is DataFailure) {
      emit(ProfileFailure(result.error ?? 'Logout failed'));
    }
  }

  Future<void> _onDisplayNameSubmitted(
    ProfileDisplayNameSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    final currentProfile = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : state is ProfileSaving
            ? (state as ProfileSaving).profile
            : null;

    if (currentProfile != null) {
      emit(ProfileSaving(currentProfile));
    }

    final result = await updateDisplayNameUseCase(params: event.displayName);
    if (result is DataFailure) {
      emit(ProfileFailure(
        result.error ?? 'Failed to update profile',
        profile: currentProfile,
      ));
    }
  }

  @override
  Future<void> close() async {
    await _profileSubscription?.cancel();
    return super.close();
  }
}
