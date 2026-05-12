import '../../../../core/data_sources/usecase.dart';
import '../entity/place_entity.dart';
import '../repository/home_repository.dart';

class WatchPlacesUseCase implements Usecase<Stream<List<PlaceEntity>>, void> {
  final HomeRepository repository;

  WatchPlacesUseCase(this.repository);

  @override
  Future<Stream<List<PlaceEntity>>> call({void params}) async {
    return repository.watchPlaces();
  }
}
