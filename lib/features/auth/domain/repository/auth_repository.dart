



import 'package:place_finder_app/core/data_sources/data_state.dart';

import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<DataState<void>> register(UserEntity user);
  Future<DataState<UserEntity>> login(UserEntity user);
  Future<DataState<void>> logout();
}
