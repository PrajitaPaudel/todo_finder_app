
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data_sources/data_state.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';

import '../model/user_model.dart';
import '../service/logout_services.dart';
import '../service/register_services.dart';


class AuthRepositoryImpl implements AuthRepository {
  final RegisterServices services;
  final LogoutServices logoutServices;

  AuthRepositoryImpl(this.services, this.logoutServices);

  @override
  Future<DataState<void>> register(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);

      await services.register(userModel);


      return DataSuccess(null);
    } on FirebaseAuthException catch (e) {
      return DataFailure(e.message ?? "Firebase auth error");
    } catch (e) {
      return DataFailure(e.toString());
    }
  }

  @override
  Future<DataState<UserEntity>> login(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);

  await services.login(userModel);

      return DataSuccess(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return DataFailure(e.message ?? "Firebase auth error");
    } catch (e) {
      return DataFailure(e.toString());
    }
  }

  @override
  Future<DataState<void>> logout() async {
    try {
      await logoutServices.logout();
      return DataSuccess(null);
    } on FirebaseAuthException catch (e) {
      return DataFailure(e.message ?? "Firebase auth error");
    } catch (e) {
      return DataFailure(e.toString());
    }
  }
}
