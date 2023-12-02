import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
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
        await expenseRepository.addExpense(expense.copyWith(
          userId: user.uid, 
          createdAt: DateTime.now(),
          ));
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    final expenseRepository = ref.read(ExpenseRepositoryProvider);
    await expenseRepository.deleteExpense(expense);
  }

  Future<String?> uploadReceipt(Uint8List bytes) async {
     try {
      String randomId = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('receipts/$randomId.png');

      await storageReference.putData(bytes);
      return await storageReference.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}

final expenseControllerProvider = AsyncNotifierProvider<ExpenseController, List<Expense>>(
  () => ExpenseController(),
);