

import '../../domain/entity/user_entity.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String email;
  final String password;

  UserModel({
    this.uid,
    this.name,
    required this.email,
    required this.password,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }


  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      password: entity.password,
    );
  }


  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      password: password,
    );
  }
}