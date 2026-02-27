//* Settings screen events — language, theme, haptic.
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base type for settings screen events.
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load initial settings from storage.
final class SettingsLoaded extends SettingsEvent {
  const SettingsLoaded();
}

/// User toggled language (en ↔ ar).
class SettingsLanguageToggled extends SettingsEvent {
  const SettingsLanguageToggled({required this.currentLocale});

  final Locale currentLocale;

  @override
  List<Object?> get props => [currentLocale];
}

/// User changed theme mode (light / dark / system).
class SettingsThemeChanged extends SettingsEvent {
  const SettingsThemeChanged({required this.themeMode});

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

/// User toggled haptic feedback.
class SettingsHapticToggled extends SettingsEvent {
  const SettingsHapticToggled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

/// User requested logout — clear token, userName, set isLoggedIn false.
class SettingsLogoutRequested extends SettingsEvent {
  const SettingsLogoutRequested();
}
