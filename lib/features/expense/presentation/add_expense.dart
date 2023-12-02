import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_management/features/expense/application/expense_controller.dart';
import 'package:money_management/features/expense/domain/expense.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';

class AddExpense extends ConsumerStatefulWidget {
  AddExpense({
    super.key, 
    required this.friends,
  });

  final List<UserProfile> friends;
  Expense expense = const Expense(
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
  String? receiptUrl;

  Future<void> _addExpense() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ref.read(expenseControllerProvider.notifier).addExpense(widget.expense.copyWith(
      name: _nameTextEditingController.text,
      description: _descriptionTextEditingController.text,
      amount: double.parse(_amountTextEditingController.text),
      receiptUrl: receiptUrl,
    ));
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Saved'),
      ),
    );
    Navigator.of(context).pop();
    return ref.refresh(expenseControllerProvider);
  }

  Future<void> _uploadReceipt() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final expenseController = ref.read(expenseControllerProvider.notifier);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      receiptUrl = await expenseController.uploadReceipt(bytes);
      if (receiptUrl != null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Receipt uploaded'),
        ),
      );
      setState(() {});
      
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Error uploading receipt'),
        ),
      );
    }
    }    
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
    _descriptionTextEditingController.text = widget.expense.description;
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (receiptUrl != null)
                      Image.network(receiptUrl!),
                    if (receiptUrl == null)
                      const Text('No receipt uploaded'),
                    const Divider(),
                    ElevatedButton(
                      onPressed: _uploadReceipt,
                      child: const Text('Upload Receipt'),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Split with your friends'),
                    if (widget.expense.share != null) 
                      for (final item in widget.expense.share!.entries)
                        ListTile(
                          title: Text(widget.friends.firstWhere((element) => element.uid == item.key).name),
                          trailing: Text(item.value.toString()),
                        ), 
                    const Divider(),
                    ElevatedButton(
                      onPressed: showAddSplitDialog,
                      child: const Text('Split'),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addExpense,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void showAddSplitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String friendUid = widget.friends.isNotEmpty ? widget.friends[0].uid : '';
        String amount = '';
        return AlertDialog(
          title: const Text('Split your expense'),
          content: Column(
            children: [
              DropdownButtonFormField(
                value: friendUid,
                onChanged: (String? newValue) {
                  friendUid = newValue!;
                },
                items: widget.friends.map<DropdownMenuItem<String>>((UserProfile value) {
                  return DropdownMenuItem<String>(
                    value: value.uid,
                    child: Text(value.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Friend',
                ),
                menuMaxHeight: 300,
              ),
              TextFormField(
                controller: TextEditingController(text: amount),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                onChanged: (String newValue) {
                  amount = newValue;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  widget.expense = widget.expense.copyWith(
                    share: {
                      ...widget.expense.share ?? {},
                      friendUid: int.parse(amount),
                    },
                  );
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}