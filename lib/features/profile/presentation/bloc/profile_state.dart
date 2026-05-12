import '../../domain/entity/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  ProfileLoaded(this.profile);
}

class ProfileSaving extends ProfileState {
  final ProfileEntity profile;

  ProfileSaving(this.profile);
}

class ProfileFailure extends ProfileState {
  final String message;
  final ProfileEntity? profile;

  ProfileFailure(this.message, {this.profile});
}

class ProfileLogoutSuccess extends ProfileState {}
