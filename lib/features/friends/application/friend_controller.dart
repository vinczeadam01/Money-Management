import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/friends/infrastructure/providers.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';

class FriendController extends AsyncNotifier<List<UserProfile>> {

  @override
  Future<List<UserProfile>> build() async {
    final friendRepository = ref.watch(friendRepositoryProvider);
    final user = ref.watch(authControllerProvider);
    return switch (user) {
      Unknown() ||
      Unauthenticated() =>
        [
          const UserProfile(
            uid: '1',
            phone: '123456789',
            name: 'John Doe',
            email: 'asd@asd.com'
          )
        ].toList(),
      Authenticated(:final user) =>
        await friendRepository.getFriends(user.uid),
    };
  }

  Future<List<UserProfile>> getPotentialFriends() async {
    final friendRepository = ref.watch(friendRepositoryProvider);
    final user = ref.watch(authControllerProvider);
    return switch (user) {
      Unknown() ||
      Unauthenticated() =>
        [
          const UserProfile(
            uid: '1',
            phone: '123456789',
            name: 'John Doe',
            email: 'asd@asd.com'
          )
        ].toList(),
      Authenticated(:final user) =>
        await friendRepository.getPotentialFriends(user.uid),
    };
  }

  void addFriend(String friendUid) async {
    final friendRepository = ref.watch(friendRepositoryProvider);
    final user = ref.watch(authControllerProvider);
    return switch (user) {
      Unknown() ||
      Unauthenticated() =>
        [
          const UserProfile(
            uid: '1',
            phone: '123456789',
            name: 'John Doe',
            email: 'asd@asd.com'
          )
        ].toList(),
      Authenticated(:final user) =>
        await friendRepository.addFriend(user.uid, friendUid),
    };
  }

  void removeFriend(String friendUid) async {
    final friendRepository = ref.watch(friendRepositoryProvider);
    final user = ref.watch(authControllerProvider);
    return switch (user) {
      Unknown() ||
      Unauthenticated() =>
        [
          const UserProfile(
            uid: '1',
            phone: '123456789',
            name: 'John Doe',
            email: 'asd@asd.com'
          )
        ].toList(),
      Authenticated(:final user) =>
        await friendRepository.removeFriend(user.uid, friendUid),
    };
  }
}

final friendControllerProvider =
    AsyncNotifierProvider<FriendController, List<UserProfile>>(
  () => FriendController(),
);

