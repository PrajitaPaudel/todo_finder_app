import '../../domain/entity/place_entity.dart';

abstract class HomeEvent {}

class HomeStarted extends HomeEvent {}

class HomePlacesUpdated extends HomeEvent {
  final List<PlaceEntity> places;

  HomePlacesUpdated(this.places);
}

class HomeErrorOccurred extends HomeEvent {
  final String message;

  HomeErrorOccurred(this.message);
}
