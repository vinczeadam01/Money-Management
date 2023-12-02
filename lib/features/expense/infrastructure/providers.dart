import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/expense/domain/expense_repository.dart';
import 'package:money_management/features/expense/infrastructure/firebase_expense_repository.dart';

final ExpenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return FirebaseExpenseRepository();
});