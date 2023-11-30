import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/profile/infrastructure/providers.dart';

class AvatarController extends AsyncNotifier<String> {
  @override
  Future<String> build() {
    return ref.watch(avatarRepositoryProvider).getAvatar();
  }

  Future<void> saveAvatar(Uint8List bytes) async {
    await ref.watch(avatarRepositoryProvider).saveAvatar(bytes);
    state = await AsyncValue.guard(
      () => ref.read(avatarRepositoryProvider).getAvatar(),
    );
  }
}

final avatarControllerProvider =
    AsyncNotifierProvider<AvatarController, String>(
  () => AvatarController(),
);
