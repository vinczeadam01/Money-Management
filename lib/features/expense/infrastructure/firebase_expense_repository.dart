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
  Future<List<Expense>> getExpenses(String userId) {
    // the document id is the uid of the expense
    return _db
      .collection(_expenseCollection)
      .where('userId', isEqualTo: userId)
      .get()
      .then((snapshot) {
        return snapshot.docs.map((doc) => Expense.fromDoc(doc)).toList();
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