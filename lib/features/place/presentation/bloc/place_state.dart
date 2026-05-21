
import 'package:place_finder_app/features/place/domain/entity/place_entity.dart';

abstract class PlaceState {}

final class PlaceInitial extends PlaceState {}

final class PlaceLoadingState extends PlaceState {}

final class PlaceLoadedState extends PlaceState {
  final List<TodoEntity> entity;
  PlaceLoadedState(this.entity);
}

final class PaceLoadedErrorState extends PlaceState {
  final String message;
  PaceLoadedErrorState(this.message);

}
