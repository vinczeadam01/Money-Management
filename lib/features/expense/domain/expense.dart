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
    List<Map<String, int>>? share,
  }) = _Expense;


  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}

