import '../../domain/entity/profile_entity.dart';

abstract class ProfileEvent {}

class ProfileStarted extends ProfileEvent {}

class ProfileDisplayNameSubmitted extends ProfileEvent {
  final String displayName;

  ProfileDisplayNameSubmitted(this.displayName);
}

class ProfileLogoutRequested extends ProfileEvent {}

class ProfileChanged extends ProfileEvent {
  final ProfileEntity profile;

  ProfileChanged(this.profile);
}

class ProfileErrorOccurred extends ProfileEvent {
  final String message;

  ProfileErrorOccurred(this.message);
}
