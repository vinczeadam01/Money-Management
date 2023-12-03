import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/core/domain/user.dart';
import 'package:money_management/features/core/presentation/app_drawer.dart';
import 'package:money_management/features/profile/application/profile_controller.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';
import 'package:money_management/features/profile/presentation/profile_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: switch (authState) {
        Unknown() => const Center(
            child: CircularProgressIndicator(),
          ),
        Unauthenticated() => const _Unauthenticated(),
        Authenticated(:final user) => _ProfileScreen(user: user),
      },
    );
  }
}

class _ProfileScreen extends ConsumerWidget {
  const _ProfileScreen({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final userProfileAsyncValue = ref.watch(profileControllerProvider);
    return switch (userProfileAsyncValue) {
      AsyncError() => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(localizations.canNotLoadProfile),
            ],
          ),
        ),
      AsyncData(:final value) => _ProfileDetails(
          user: user,
          userProfile: value,
        ),
      _ => const Center(
          child: CircularProgressIndicator(),
        ),
    };
  }
}

class _ProfileDetails extends ConsumerStatefulWidget {
  const _ProfileDetails({
    required this.user,
    required this.userProfile,
  });

  final User user;
  final UserProfile userProfile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends ConsumerState<_ProfileDetails> {
  late final TextEditingController _phoneTextEditingController;
  late final TextEditingController _nameTextEditingController;

  Future<void> _updateProfile() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localizations = AppLocalizations.of(context)!;
    await ref.read(profileControllerProvider.notifier).updateProfile(
          widget.userProfile.copyWith(
            phone: _phoneTextEditingController.text,
            name: _nameTextEditingController.text,
          ),
        );
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(localizations.saved),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _phoneTextEditingController = TextEditingController(
      text: widget.userProfile.phone,
    );
    _nameTextEditingController = TextEditingController(
      text: widget.userProfile.name,
    );
  }

  @override
  void didUpdateWidget(covariant _ProfileDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    _phoneTextEditingController.text = widget.userProfile.phone ?? '';
    _nameTextEditingController.text = widget.userProfile.name;
  }

  @override
  void dispose() {
    _phoneTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const ProfileAvatar(),
          TextField(
            controller: TextEditingController(
              text: widget.user.email,
            ),
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _nameTextEditingController,
            decoration: InputDecoration(
              labelText: localizations.name,
            ),
          ),
          TextField(
            controller: _phoneTextEditingController,
            decoration: InputDecoration(
              labelText: localizations.phone,
            ),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: _updateProfile,
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }
}

class _Unauthenticated extends StatelessWidget {
  const _Unauthenticated();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('You are not logged in'),
        ElevatedButton(
          onPressed: () {
            context.go('/sign-up');
          },
          child: const Text('Sign up'),
        ),
        ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
