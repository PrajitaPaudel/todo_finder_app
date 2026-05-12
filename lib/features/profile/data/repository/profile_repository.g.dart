import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data_sources/data_state.dart';
import '../../domain/entity/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../service/profile_services.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileServices services;

  ProfileRepositoryImpl(this.services);

  @override
  Stream<ProfileEntity> watchProfile() {
    return services.watchProfile().map((model) => model.toEntity());
  }

  @override
  Future<DataState<void>> updateDisplayName(String displayName) async {
    try {
      await services.updateDisplayName(displayName);
      return DataSuccess(null);
    } on FirebaseAuthException catch (e) {
      return DataFailure(e.message ?? 'Firebase auth error');
    } catch (e) {
      return DataFailure(e.toString());
    }
  }
}
