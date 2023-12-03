import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    this.onChanged,
    this.errorText,
  });

  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        label: Text(localization.name),
        icon: const Icon(Icons.person),
        errorText: errorText,
      ),
    );
  }
}
