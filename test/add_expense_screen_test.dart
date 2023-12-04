import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_management/features/auth/domain/auth_repository.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/auth/infrastructure/providers.dart';
import 'package:money_management/features/core/domain/user.dart';
import 'package:money_management/features/expense/presentation/add_expense.dart';
import 'package:money_management/features/expense/presentation/expenses_screen.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';
import 'package:money_management/features/profile/infrastructure/dummy_profile_repository.dart';
import 'package:money_management/features/profile/infrastructure/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:money_management/firebase_options.dart';


class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('Expenses screen', () {
    final mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.watch()).thenAnswer(
      (_) => Stream.value(
        Authenticated(
          user: User(uid: '1', name: 'John Doe', email: 'test@example.com'),
        ),
      ),
    );

    testWidgets('shows friends on add expense screen', (widgetTester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final friends = [
        const UserProfile(
          uid: '2',
          name: 'John Friend',
          email: 'john.friend@mail.com', 
          phone: '',
        ),
      ];

      await widgetTester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider
                .overrideWith((ref) => DummyProfileRepository()),
            authRepositoryProvider.overrideWith((ref) => mockAuthRepository),
          ],
          child: MaterialApp(
            home: AddExpense(friends: friends,),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('hu'), // Hungarian
            ],
            locale: const Locale('en'),
          ),
        ),
      );
      await widgetTester.pump();

      await widgetTester.tap(find.widgetWithText(ElevatedButton, "Split"));
      await widgetTester.pump();

      for (final friend in friends) {
        expect(find.text(friend.name), findsOneWidget);
      }
    });

    testWidgets('opens addExpenses screen', (widgetTester) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await widgetTester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider
                .overrideWith((ref) => DummyProfileRepository()),
            authRepositoryProvider.overrideWith((ref) => mockAuthRepository),
          ],
          child: const MaterialApp(
            home: ExpensesScreen(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'), // English
              Locale('hu'), // Hungarian
            ],
            locale: Locale('hu'),
          ),
        ),
      );
      await widgetTester.pump();

      await widgetTester.tap(find.byIcon(Icons.add));
      await widgetTester.pump();
      expect(find.text('Kiadás hozzáadása'), findsOneWidget);
    });
  });
}