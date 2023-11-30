import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_management/features/profile/application/avatar_controller.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final avatarController = ref.read(avatarControllerProvider.notifier);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      await avatarController.saveAvatar(bytes);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Avatar updated'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarAsyncValue = ref.watch(avatarControllerProvider);
    return GestureDetector(
      onTap: () {
        _onTap(context, ref);
      },
      child: CircleAvatar(
        radius: 75,
        backgroundImage: avatarAsyncValue.when(
          data: (String imageUrl) => NetworkImage(imageUrl),
          loading: () => null,
          error: (dynamic error, StackTrace? stackTrace) => null,
        ),
        child: avatarAsyncValue.when(
          loading: () => const CircularProgressIndicator(),
          error: (dynamic error, StackTrace? stackTrace) => const Icon(Icons.error),
          data: (_) => null,
        ),
      ),
    );
  }
}