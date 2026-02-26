//* Settings screen state — userName, locale, themeMode, hapticEnabled.
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Immutable state for the settings screen.
final class SettingsState extends Equatable {
  const SettingsState({
    this.userName = 'User',
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.system,
    this.hapticEnabled = true,
    this.status = SettingsStatus.initial,
  });

  final String userName;
  final Locale locale;
  final ThemeMode themeMode;
  final bool hapticEnabled;
  final SettingsStatus status;

  SettingsState copyWith({
    String? userName,
    Locale? locale,
    ThemeMode? themeMode,
    bool? hapticEnabled,
    SettingsStatus? status,
  }) =>
      SettingsState(
        userName: userName ?? this.userName,
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
        hapticEnabled: hapticEnabled ?? this.hapticEnabled,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [userName, locale, themeMode, hapticEnabled, status];
}

/// Settings load/update status.
enum SettingsStatus {
  initial,
  loading,
  success,
  fail,
}
