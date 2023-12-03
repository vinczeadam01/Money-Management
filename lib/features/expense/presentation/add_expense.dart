import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_management/features/expense/application/expense_controller.dart';
import 'package:money_management/features/expense/domain/expense.dart';
import 'package:money_management/features/profile/domain/user_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddExpense extends ConsumerStatefulWidget {
  AddExpense({
    super.key, 
    required this.friends,
    this.expense = const Expense(
      name: '',
      description: '',
      amount: 0,
    ),
    this.isUpdate = false,
  });

  final List<UserProfile> friends;
  Expense expense;
  final isUpdate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {
  late final TextEditingController _nameTextEditingController;
  late final TextEditingController _descriptionTextEditingController;
  late final TextEditingController _amountTextEditingController;
  String? receiptUrl;

  Future<void> _addExpense() async {
    final localizations = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ref.read(expenseControllerProvider.notifier).addExpense(widget.expense.copyWith(
      name: _nameTextEditingController.text,
      description: _descriptionTextEditingController.text,
      amount: double.parse(_amountTextEditingController.text),
      receiptUrl: receiptUrl,
    ));
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(localizations.saved),
      ),
    );
    Navigator.of(context).pop();
    return ref.refresh(expenseControllerProvider);
  }

  Future<void> updateExpense() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localizations = AppLocalizations.of(context)!;
    ref.read(expenseControllerProvider.notifier).updateExpense(widget.expense.copyWith(
      name: _nameTextEditingController.text,
      description: _descriptionTextEditingController.text,
      amount: double.parse(_amountTextEditingController.text),
      receiptUrl: receiptUrl,
    ));
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(localizations.saved),
      ),
    );
    Navigator.of(context).pop();
    return ref.refresh(expenseControllerProvider);
  }


  Future<void> _uploadReceipt() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final expenseController = ref.read(expenseControllerProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      receiptUrl = await expenseController.uploadReceipt(bytes);
      if (receiptUrl != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(localizations.receiptUploaded),
        ),
      );
      setState(() {});
      
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(localizations.errorUploadingReceipt),
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
    final localization = AppLocalizations.of(context)!;
    String appBarTitle = widget.isUpdate ? localization.editExpense : localization.addExpense;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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
                      decoration: InputDecoration(
                        labelText: localization.name,
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionTextEditingController,
                      decoration: InputDecoration(
                        labelText: localization.description,
                      ),
                    ),
                    TextFormField(
                      controller: _amountTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: localization.amount,
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
                      Text(localization.noReceiptUploaded),
                    const Divider(),
                    ElevatedButton(
                      onPressed: _uploadReceipt,
                      child: Text(localization.uploadReceipt),
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
                     Text(localization.splitWithYourFriends),
                    if (widget.expense.shareWith != null) 
                      for (final item in widget.expense.shareWith!.entries)
                        ListTile(
                          title: Text(widget.friends.firstWhere((element) => element.uid == item.key).name),
                          trailing: Text(item.value.toString()),
                        ), 
                    const Divider(),
                    ElevatedButton(
                      onPressed: () => showAddSplitDialog(localization),
                      child: Text(localization.split),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: widget.isUpdate ? updateExpense : _addExpense,
              child: Text(localization.save),
            ),
          ],
        ),
      ),
    );
  }

  void showAddSplitDialog(AppLocalizations localization) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String friendUid = widget.friends.isNotEmpty ? widget.friends[0].uid : '';
        String amount = '';
        return AlertDialog(
          title: Text(localization.splitYourExpense),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                decoration: InputDecoration(
                  labelText: localization.friend,
                ),
                menuMaxHeight: 300,
              ),
              TextFormField(
                controller: TextEditingController(text: amount),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: localization.amount,
                ),
                onChanged: (String newValue) {
                  amount = newValue;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(localization.add),
              onPressed: () {
                setState(() {
                  widget.expense = widget.expense.copyWith(
                    shareWith: {
                      ...widget.expense.shareWith ?? {},
                      friendUid: int.parse(amount),
                    },
                  );
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(localization.cancel),
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