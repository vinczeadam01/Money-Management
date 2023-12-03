// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      uid: json['uid'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      receiptUrl: json['receiptUrl'] as String?,
      shareWith: (json['shareWith'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
      isShared: json['isShared'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{'uid': instance.uid,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'amount': instance.amount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'receiptUrl': instance.receiptUrl,
      'shareWith': instance.shareWith,
    };
