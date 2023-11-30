import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/features/core/presentation/app_drawer.dart';
import 'package:money_management/features/core/presentation/email_text_field.dart';
import 'package:money_management/features/core/presentation/password_text_field.dart';
import 'package:money_management/features/login/application/login_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _onSubmit(WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(ref.context);
    final router = GoRouter.of(ref.context);
    final loginController = ref.read(loginControllerProvider.notifier);
    try {
      await loginController.login();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Welcome back!'),
        ),
      );
      router.go('/profile');
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to login'),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(ref.context);
    final router = GoRouter.of(ref.context);
    final loginController = ref.read(loginControllerProvider.notifier);
    try {
      await loginController.loginWithGoogle();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Welcome back!'),
        ),
      );
      router.go('/profile');
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to login'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const Icon(
            Icons.money_outlined,
            size: 128,
          ),
          const Text('Welcome!'),
          EmailTextField(
            onChanged: ref.read(loginControllerProvider.notifier).updateEmail,
            errorText: loginForm.emailErrorText,
          ),
          PasswordTextField(
            onChanged:
                ref.read(loginControllerProvider.notifier).updatePassword,
            errorText: loginForm.passwordErrorText,
          ),
          ElevatedButton(
            onPressed: () {
              _onSubmit(ref);
            },
            child: const Text('Login'),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              _signInWithGoogle(ref);
            },
            child: const Text('Sign in with Google'),
          ),
          const Divider(),
          const Text('or'),
          TextButton(
            onPressed: () {
              context.go('/sign-up');
            },
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}
