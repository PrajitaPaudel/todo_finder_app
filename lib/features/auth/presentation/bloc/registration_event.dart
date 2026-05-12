
import '../../domain/entity/user_entity.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final UserEntity user;

  RegisterSubmitted(this.user);
}
