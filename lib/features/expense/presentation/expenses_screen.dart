import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/auth/application/auth_controller.dart';
import 'package:money_management/features/auth/domain/auth_state.dart';
import 'package:money_management/features/core/presentation/app_drawer.dart';
import 'package:money_management/features/expense/application/expense_controller.dart';
import 'package:money_management/features/expense/presentation/add_expense.dart';
import 'package:money_management/features/expense/presentation/expense_details.dart';
import 'package:money_management/features/friends/infrastructure/providers.dart';
import 'package:money_management/features/profile/infrastructure/providers.dart';


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
      floatingActionButton: authState is Authenticated ? FloatingActionButton(
        onPressed: () async {
          final friends = await friendRepository.getFriends(authState.user.uid);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpense(friends: friends),
            ),
          );
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}


class _ExpensesListView extends ConsumerWidget {
  const _ExpensesListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExpenses = ref.watch(expenseControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return switch (asyncExpenses) {
      AsyncData(:final value) => ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          final expense = value[index];
          return ListTile(
            title: Row(
              children: [
                Text(expense.name),
                if (expense.isShared) const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.people),
                ),
              ],
            ),
            subtitle: Text(expense.amount.toString()),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  enabled: !expense.isShared,
                  child: const Text('Edit'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  enabled: !expense.isShared,
                  child: const Text('Delete'),
                ),
              ],
              onSelected: (method) async {
                if (method == 'edit' && authState is Authenticated) {
                  final friends = await ref.read(friendRepositoryProvider).getFriends(authState.user.uid);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExpense(expense: expense, friends: friends, isUpdate: true),
                    ),
                  );
                } else if (method == 'delete') {
                  await ref.read(expenseControllerProvider.notifier).deleteExpense(expense);
                  return ref.refresh(expenseControllerProvider);
                }
              },
            ),
            onTap: () async {
              final allUser = await ref.read(profileRepositoryProvider).getAllUser();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseDetails(expense: expense, allUser: allUser),
                ),
              );
            }
          );
        },
      ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}