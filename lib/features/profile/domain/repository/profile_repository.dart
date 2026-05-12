import '../../../../core/data_sources/data_state.dart';
import '../entity/profile_entity.dart';

abstract class ProfileRepository {
  Stream<ProfileEntity> watchProfile();
  Future<DataState<void>> updateDisplayName(String displayName);
}
