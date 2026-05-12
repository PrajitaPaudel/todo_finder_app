import '../entity/place_entity.dart';

abstract class HomeRepository {
  Stream<List<PlaceEntity>> watchPlaces();
}
