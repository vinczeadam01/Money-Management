import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/expense/application/expense_controller.dart';
import 'package:money_management/features/expense/domain/expense.dart';

class AddExpense extends ConsumerStatefulWidget {
  const AddExpense({
    required this.friends,
  });

  final List<User> friends;
  final Expense expense = const Expense(
    name: '',
    description: '',
    amount: 0,
  );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {
  late final TextEditingController _nameTextEditingController;
  late final TextEditingController _descriptionTextEditingController;
  late final TextEditingController _amountTextEditingController;


  Future<void> _addExpense() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ref.read(expenseControllerProvider.notifier).addExpense(widget.expense.copyWith(
      name: _nameTextEditingController.text,
      description: _descriptionTextEditingController.text,
      amount: double.parse(_amountTextEditingController.text),
    
    ));
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Saved'),
      ),
    );
    Navigator.of(context).pop();
    ref.refresh(expenseControllerProvider);
  }

  @override
  void initState() {
    super.initState();
    _nameTextEditingController = TextEditingController(
      text: widget.expense.name,
    );
    _descriptionTextEditingController = TextEditingController(
      text: widget.expense.description,
    );
    _amountTextEditingController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant AddExpense oldWidget) {
    super.didUpdateWidget(oldWidget);
    _nameTextEditingController.text = widget.expense.name;
    _descriptionTextEditingController.text = widget.expense.description ?? '';
    _amountTextEditingController.text = widget.expense.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameTextEditingController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: _descriptionTextEditingController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: _addExpense,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}