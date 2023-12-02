import 'package:money_management/features/expense/domain/expense.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<List<Expense>> getExpenses(String userId);
}
