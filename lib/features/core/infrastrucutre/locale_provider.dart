import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_currentLocale);

  static Locale _currentLocale = const Locale('hu');

  void setLocale(Locale newLocale) {
    _currentLocale = newLocale;
  }
}

final localeNotifierProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
