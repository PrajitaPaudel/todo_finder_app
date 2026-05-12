import '../../../../core/data_sources/usecase.dart';
import '../entity/profile_entity.dart';
import '../repository/profile_repository.dart';

class WatchProfileUseCase implements Usecase<Stream<ProfileEntity>, void> {
  final ProfileRepository repository;

  WatchProfileUseCase(this.repository);

  @override
  Future<Stream<ProfileEntity>> call({void params}) async {
    return repository.watchProfile();
  }
}
