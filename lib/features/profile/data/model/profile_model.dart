import '../../domain/entity/profile_entity.dart';

class ProfileModel {
  final String uid;
  final String displayName;
  final String email;

  const ProfileModel({
    required this.uid,
    required this.displayName,
    required this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      uid: entity.uid,
      displayName: entity.displayName,
      email: entity.email,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      uid: uid,
      displayName: displayName,
      email: email,
    );
  }
}
