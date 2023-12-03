import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management/features/expense/domain/expense.dart';
import 'package:money_management/features/expense/domain/expense_repository.dart';

const _expenseCollection = 'expenses';

class FirebaseExpenseRepository extends ExpenseRepository {
  final _db = FirebaseFirestore.instance;


  @override
  Future<void> addExpense(Expense expense) async {
    await _db
    .collection(_expenseCollection)
    .add(expense.toJson());
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    await _db
      .collection(_expenseCollection)
      .doc(expense.uid)
      .delete();
  }

  @override
  Future<List<Expense>> getExpenses(String userId) async {
    final ownExpensesDocuments =  _db
      .collection(_expenseCollection)
      .where('userId', isEqualTo: userId)
      .get();

    final sharedExpensesDocuments = _db
      .collection(_expenseCollection)
      .where('shareWith.$userId', isGreaterThan: 0)
      .get();

    return Future.wait([ownExpensesDocuments, sharedExpensesDocuments])
      .then((value) {
        final ownExpenses = value[0].docs.map((doc) => Expense.fromDoc(doc)).toList();
        final sharedExpenses = value[1].docs.map((doc) => Expense.fromDoc(doc, isShared: true)).toList();
        final allExpenses = [...ownExpenses, ...sharedExpenses];

        allExpenses.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        return allExpenses;
      });
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _db
        .collection(_expenseCollection)
        .doc(expense.uid)
        .update(expense.toJson());
  }

}