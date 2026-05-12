import '../../domain/entity/place_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PlaceEntity> places;

  HomeLoaded(this.places);
}

class HomeEmpty extends HomeState {}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}
