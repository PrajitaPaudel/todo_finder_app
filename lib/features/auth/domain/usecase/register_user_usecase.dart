

import 'package:place_finder_app/core/data_sources/data_state.dart';
import 'package:place_finder_app/core/data_sources/usecase.dart';
import 'package:place_finder_app/features/auth/domain/entity/user_entity.dart';

import '../repository/auth_repository.dart';

class RegisterUserUseCase implements Usecase<DataState<void>,UserEntity>{
  final AuthRepository repository;
  RegisterUserUseCase(this.repository);
  @override
  Future<DataState<void>> call({UserEntity? params}) async{
   return await repository.register(params!);
  }
}