


import '../../domain/entity/place_entity.dart';

class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  /// From JSON → Model
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }


  /// Model → Entity
  TodoEntity toEntity() {
    return TodoEntity(
      userId: userId,
      id: id,
      title: title,
      completed: completed,
    );
  }


}