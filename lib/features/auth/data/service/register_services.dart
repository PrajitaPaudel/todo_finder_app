
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class RegisterServices {
  final FirebaseAuth firebaseAuth;

  RegisterServices(this.firebaseAuth);

  Future<UserCredential> register(UserModel userModel) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      return result;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }

  Future<UserCredential> login(UserModel userModel) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      return result;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "This email is already registered.";
      case 'invalid-email':
        return "Invalid email format.";
      case 'weak-password':
        return "Password is too weak.";
      case 'operation-not-allowed':
        return "Email/password sign up is disabled.";
      default:
        return e.message ?? "Authentication error occurred.";
    }
  }
}