import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/profile/presentation/profile_avatar.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    return Drawer(
      child: ListView(
        children: [
          if (authState case Unauthenticated()) ...[
            ListTile(
              title: const Text('Login'),
              onTap: () {
                context.go('/login');
              },
            ),
            ListTile(
              title: const Text('Sign up'),
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
              title: const Text('Home'),
              onTap: () {
                context.go('/home');
              },
            ),
             ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Friends'),
              onTap: () {
                context.go('/friends');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                context.go('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                ref.read(authControllerProvider.notifier).signOut();
                context.go('/');
              },
            ),
          ],
        ],
      ),
    );
  }
}
