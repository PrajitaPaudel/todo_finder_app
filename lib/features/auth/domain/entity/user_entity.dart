
class UserEntity {
  final String? uid;
  final String? name;
  final String email;
  final String password;

  UserEntity({
    this.uid,
    this.name,
    required this.email,
    required this.password,
  });
}