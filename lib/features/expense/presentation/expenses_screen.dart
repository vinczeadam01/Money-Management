import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/core/presentation/app_drawer.dart';
import 'package:money_management/features/expense/application/expense_controller.dart';
import 'package:money_management/features/expense/presentation/add_expense.dart';
import 'package:money_management/features/friends/infrastructure/providers.dart';


class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref)  {
    final friendRepository = ref.watch(friendRepositoryProvider);
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      drawer: const AppDrawer(),
      body: const _ExpensesListView(),
      floatingActionButton: switch (authState) {
        Unknown() || Unauthenticated() => const Center(
            child: CircularProgressIndicator(),
          ),
        Authenticated(:final user) => FloatingActionButton(
          onPressed: () async {
            final friends = await friendRepository.getFriends(user.uid);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpense(friends: friends),
              ),
            );
          },
          child: const Icon(Icons.add),
        )
      },
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
            subtitle: Text(expense.amount.toString()),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Delete'),
                  value: expense,
                ),
              ],
              onSelected: (expense) async {
                await ref.read(expenseControllerProvider.notifier).deleteExpense(expense);
                ref.refresh(expenseControllerProvider);
              },
            ),
          );
        },
      ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}