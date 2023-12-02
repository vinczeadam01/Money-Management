import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/expense/domain/expense.dart';
import 'package:money_management/features/expense/infrastructure/providers.dart';

class ExpenseController extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    final expenseRepository = ref.watch(ExpenseRepositoryProvider);
    final user = ref.watch(authControllerProvider);
    return switch (user) {
      Unknown() ||
      Unauthenticated() =>
        throw const Unauthenticated(),
      Authenticated(:final user) =>
        await expenseRepository.getExpenses(user.uid),
    };
  }

  void addExpense(Expense expense) async {
    final expenseRepository = ref.read(ExpenseRepositoryProvider);
    final user = ref.read(authControllerProvider);
    switch (user) {
      case Unknown() || Unauthenticated():
        throw const Unauthenticated();
      case Authenticated(:final user):
        await expenseRepository.addExpense(expense.copyWith(userId: user.uid));
    }
  }
}

final expenseControllerProvider = AsyncNotifierProvider<ExpenseController, List<Expense>>(
  () => ExpenseController(),
);