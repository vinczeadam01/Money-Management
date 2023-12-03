import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management/features/core/infrastrucutre/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeNotifierProvider.notifier);

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      onSelected: (Locale locale) {
        localeNotifier.setLocale(locale);
        return ref.refresh(localeNotifierProvider);
      },
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem(
            value: Locale('en'),
            child: Text('English'),
          ),
          PopupMenuItem(
            value: Locale('hu'),
            child: Text('Magyar'),
          ),
        ];
      },
      
    );
  }
}
