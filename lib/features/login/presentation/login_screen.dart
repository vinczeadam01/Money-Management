import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/features/core/presentation/app_drawer.dart';
import 'package:money_management/features/core/presentation/email_text_field.dart';
import 'package:money_management/features/core/presentation/password_text_field.dart';
import 'package:money_management/features/login/application/login_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _onSubmit(WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(ref.context);
    final router = GoRouter.of(ref.context);
    final loginController = ref.read(loginControllerProvider.notifier);
    final localizations = AppLocalizations.of(ref.context)!;

    try {
      await loginController.login();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(localizations.welcomeBack),
        ),
      );
      router.go('/home');
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(localizations.failedToLogin),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(ref.context);
    final router = GoRouter.of(ref.context);
    final loginController = ref.read(loginControllerProvider.notifier);
    final localizations = AppLocalizations.of(ref.context)!;
    try {
      await loginController.loginWithGoogle();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(localizations.welcomeBack),
        ),
      );
      router.go('/home');
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(localizations.failedToLogin),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginControllerProvider);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.login),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const Icon(
            Icons.money_outlined,
            size: 128,
          ),
          Text(localizations.welcome),
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
            child: Text(localizations.login),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              _signInWithGoogle(ref);
            },
            child: Text(localizations.signInWithGoogle),
          ),
          const Divider(),
          const Text('or'),
          TextButton(
            onPressed: () {
              context.go('/sign-up');
            },
            child: Text(localizations.signUp),
          ),
        ],
      ),
    );
  }
}
