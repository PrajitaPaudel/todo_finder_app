import '../../domain/entity/place_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../service/home_services.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeServices services;

  HomeRepositoryImpl(this.services);

  @override
  Stream<List<PlaceEntity>> watchPlaces() {
    return services
        .watchPlaces()
        .map((places) => places.map((place) => place.toEntity()).toList());
  }
}
