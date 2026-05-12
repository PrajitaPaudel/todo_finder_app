import '../../domain/entity/user_entity.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final UserEntity user;

  LoginSubmitted(this.user);
}
