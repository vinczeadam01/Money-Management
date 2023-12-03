import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/core/presentation/language_selector.dart';
import 'package:money_management/features/profile/presentation/profile_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final localization = AppLocalizations.of(context)!;
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                if (authState case Unauthenticated()) ...[
                  ListTile(
                    title: Text(localization.login),
                    onTap: () {
                      context.go('/login');
                    },
                  ),
                  ListTile(
                    title: Text(localization.signUp),
                    onTap: () {
                      context.go('/sign-up');
                    },
                  ),
                ],
                if (authState case Authenticated(:final user)) ...[
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Colors.blue),
                    accountName: Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      user.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    currentAccountPicture: const ProfileAvatar(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: Text(localization.home),
                    onTap: () {
                      context.go('/home');
                    },
                  ),
                   ListTile(
                    leading: const Icon(Icons.people),
                    title: Text(localization.friends),
                    onTap: () {
                      context.go('/friends');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(localization.profile),
                    onTap: () {
                      context.go('/profile');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(localization.logout),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).signOut();
                      context.go('/');
                    },
                  ),
                ],
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: LanguageSelector()
          ),
        ],
      ),
    );
  }
}
