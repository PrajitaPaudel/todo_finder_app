import '../../../../core/data_sources/data_state.dart';
import '../../../../core/data_sources/usecase.dart';
import '../repository/auth_repository.dart';

class LogoutUseCase implements Usecase<DataState<void>, void> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<DataState<void>> call({void params}) async {
    return repository.logout();
  }
}
