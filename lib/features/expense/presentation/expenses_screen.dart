import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/core/presentation/app_drawer.dart';
import 'package:money_management/features/expense/application/expense_controller.dart';
import 'package:money_management/features/expense/presentation/add_expense.dart';


class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      drawer: const AppDrawer(),
      body: const _ExpensesListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddExpense(friends: []),
            ),
          );
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class _ExpensesListView extends ConsumerWidget {
  const _ExpensesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExpenses = ref.watch(expenseControllerProvider);

    return switch (asyncExpenses) {
      AsyncData(:final value) => ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          final expense = value[index];
          return ListTile(
            title: Text(expense.name),
            subtitle: Text(expense.amount.toString() ?? ''),
          );
        },
      ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}