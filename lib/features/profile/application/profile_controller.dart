import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';
import 'package:money_management/features/profile/infrastructure/providers.dart';

class ProfileController extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final profileRepository = ref.watch(profileRepositoryProvider);
    final user = ref.watch(authControllerProvider);
    return switch (user) {
      Unknown() ||
      Unauthenticated() =>
        const UserProfile(uid: '', phone: ''),
      Authenticated(:final user) =>
        await profileRepository.getProfile(user.uid),
    };
  }

  Future<void> updateProfile(UserProfile profile) async {
    final profileRepository = ref.watch(profileRepositoryProvider);
    state = await AsyncValue.guard(() {
      return profileRepository.updateProfile(profile);
    });
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, UserProfile>(
  () => ProfileController(),
);
