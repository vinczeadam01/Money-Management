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
    Map<String, int>? share,
  }) = _Expense;


  factory Expense.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    var exponse = _$ExpenseFromJson(documentSnapshot.data());
    exponse = exponse.copyWith(uid: documentSnapshot.id);
    return exponse;
  }
      
}

