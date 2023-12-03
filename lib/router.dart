import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/expense/presentation/expenses_screen.dart';
import 'package:money_management/features/friends/presentation/friends_screen.dart';
import 'package:money_management/features/login/presentation/login_screen.dart';
import 'package:money_management/features/profile/presentation/profile_screen.dart';
import 'package:money_management/features/sign_up/presentation/sign_up_screen.dart';
import 'package:money_management/features/splash/presentation/splash_screen.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
    final authState = ref.watch(authControllerProvider);
  return GoRouter(
    navigatorKey: _key,
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggingIn = state.uri.toString() == '/login';
      final isSignUp = state.uri.toString() == '/sign-up';
      final isSplash = state.uri.toString() == '/';
      switch (authState) {
        case Unknown():
          return null;
        case Unauthenticated():
          if (isLoggingIn || isSignUp) {
            return null;
          }
          return '/login';
        case Authenticated():
          if (isSplash) {
            return '/profile';
          }
          if (isLoggingIn) {
            return '/profile';
          }

          return null;
      }
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: '/friends',
        builder: (context, state) => const FriendsScreen(),
      ),
    ],
  );
});