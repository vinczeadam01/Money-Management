import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/profile/domain/avatar_repository.dart';
import 'package:money_management/features/profile/domain/profile_repository.dart';
import 'package:money_management/features/profile/infrastructure/firebase_profile_repository.dart';
import 'package:money_management/features/profile/infrastructure/firebase_storage_avatar_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return FirebaseProfileRepository();
});

final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  final user = ref.watch(authControllerProvider);
  return switch (user) {
      Unknown() ||
      Unauthenticated() =>
        FirebaseStorageAvatarRepository(),
      Authenticated(:final user) =>
        FirebaseStorageAvatarRepository(user.uid),
    };
});
