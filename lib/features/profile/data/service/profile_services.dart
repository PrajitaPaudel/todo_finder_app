import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/local_storage.dart';
import '../model/profile_model.dart';

class ProfileServices {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  ProfileServices(this.firebaseAuth, this.firestore);

  Stream<ProfileModel> watchProfile() {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return Stream.error('No user is signed in.');
    }

    return firestore.collection('users').doc(user.uid).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data();
      final email = (data?['email'] as String?) ?? user.email ?? '';
      final displayNameFromDoc = data?['displayName'] as String?;
      final displayNameFromAuth = user.displayName;
      final displayName = _displayNameFromEmail(
        displayNameFromDoc?.trim().isNotEmpty == true
            ? displayNameFromDoc!.trim()
            : (displayNameFromAuth?.trim().isNotEmpty == true
                  ? displayNameFromAuth!.trim()
                  : email),
      );

      return ProfileModel(
        uid: user.uid,
        displayName: displayName,
        email: email,
      );
    });
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No user is signed in.',
      );
    }

    final userRef = firestore.collection('users').doc(user.uid);

    await userRef.set({
      'uid': user.uid,
      'displayName': displayName,
      'email': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await user.updateDisplayName(displayName);
    await LocalStorage.setString('user_name', displayName);
    if (user.email != null) {
      await LocalStorage.setString('user_email', user.email!);
    }
  }

  String _displayNameFromEmail(String value) {
    final atIndex = value.indexOf('@');
    if (atIndex > 0) {
      return value.substring(0, atIndex);
    }
    return value;
  }
}
