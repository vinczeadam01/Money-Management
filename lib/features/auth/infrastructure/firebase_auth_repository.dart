import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_management/features/auth/domain/auth_repository.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/core/domain/user.dart' as core;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository extends AuthRepository {
  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

@override
  Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

  @override
  Stream<AuthState> watch() {
    return FirebaseAuth.instance.userChanges().map((user) {
      if (user == null) {
        return const Unauthenticated();
      } else {
        return Authenticated(
          user: core.User(
            uid: user.uid,
            name: user.displayName ?? 'Unknown',
            email: user.email ?? 'Unknown',
          ),
        );
      }
    });
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
