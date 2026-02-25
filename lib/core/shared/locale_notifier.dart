import 'package:flutter/material.dart';

/// Locale notifier - allows app-wide locale changes
class LocaleNotifier {
  LocaleNotifier._();

  static LocaleNotifier? _instance;
  static LocaleNotifier get instance {
    _instance ??= LocaleNotifier._();
    return _instance!;
  }

  Function(Locale)? onLocaleChanged;

  /// Notify that locale has changed
  void notifyLocaleChanged(Locale locale) {
    onLocaleChanged?.call(locale);
  }
}

