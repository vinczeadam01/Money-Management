import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    String? uid,
    String? userId,
    required String name,
    @Default('') String description,
    @Default('') String category,
    required double amount,
    DateTime? createdAt,
    String? receiptUrl,
    Map<String, int>? shareWith,
    @Default(false) bool isShared
  }) = _Expense;


  factory Expense.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot, {bool isShared = false}) {
    var expense = _$ExpenseFromJson(documentSnapshot.data());
    expense = expense.copyWith(uid: documentSnapshot.id, isShared: isShared);
    return expense;
  }

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
      
}

