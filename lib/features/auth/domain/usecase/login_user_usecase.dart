
import '../../../../core/data_sources/data_state.dart';
import '../../../../core/data_sources/usecase.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';


class LoginUserUseCase implements Usecase<DataState<UserEntity>, UserEntity> {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  @override
  Future<DataState<UserEntity>> call({UserEntity? params}) async {
    return await repository.login(params!);
  }
}
