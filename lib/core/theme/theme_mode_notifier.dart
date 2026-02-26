//* Theme mode notifier for runtime theme switching from Settings.
//* Registered in getIt after loading saved theme from storage.

import 'package:flutter/material.dart';

import '../di/app_dependencies.dart';
import '../storage/app_storage_service.dart';

/// Holds the current [ThemeMode] and notifies listeners when it changes.
/// Use [setThemeMode] to update and persist the theme.
class ThemeModeNotifier extends ValueNotifier<ThemeMode> {
  ThemeModeNotifier(super.initial);

  /// Updates theme mode, persists to storage, and notifies listeners.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (value == mode) return;
    value = mode;
    final storage = getIt<AppStorageService>();
    await storage.setThemeMode(mode);
  }
}
