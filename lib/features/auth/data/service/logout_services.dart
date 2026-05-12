import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/local_storage.dart';

class LogoutServices {
  final FirebaseAuth firebaseAuth;

  LogoutServices(this.firebaseAuth);

  Future<void> logout() async {
    await firebaseAuth.signOut();
    await LocalStorage.setBool('is_logged_in', false);
    await LocalStorage.remove('user_name');
    await LocalStorage.remove('user_email');
  }
}
