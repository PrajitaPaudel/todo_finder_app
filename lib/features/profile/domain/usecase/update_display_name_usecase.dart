import '../../../../core/data_sources/data_state.dart';
import '../../../../core/data_sources/usecase.dart';
import '../repository/profile_repository.dart';

class UpdateDisplayNameUseCase implements Usecase<DataState<void>, String> {
  final ProfileRepository repository;

  UpdateDisplayNameUseCase(this.repository);

  @override
  Future<DataState<void>> call({String? params}) async {
    return repository.updateDisplayName(params!);
  }
}
