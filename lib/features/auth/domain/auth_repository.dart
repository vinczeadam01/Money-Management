import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';

abstract class AuthRepository {
  Stream<AuthState> watch();
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
}
