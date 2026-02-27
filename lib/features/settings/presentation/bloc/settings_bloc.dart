//* Settings BLoC — language, theme, haptic; delegates to storage and ThemeModeNotifier.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/app_dependencies.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/shared/locale_service.dart';
import '../../../../core/storage/app_storage_service.dart';
import '../../../../core/theme/theme_mode_notifier.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// BLoC for settings screen: profile, language, theme, haptic.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    AppStorageService? storage,
    ThemeModeNotifier? themeNotifier,
  })  : _storage = storage ?? getIt<AppStorageService>(),
        _themeNotifier = themeNotifier ?? getIt<ThemeModeNotifier>(),
        super(const SettingsState()) {
    on<SettingsLoaded>(_onLoaded);
    on<SettingsLanguageToggled>(_onLanguageToggled);
    on<SettingsThemeChanged>(_onThemeChanged);
    on<SettingsHapticToggled>(_onHapticToggled);
    on<SettingsLogoutRequested>(_onLogoutRequested);
  }

  final AppStorageService _storage;
  final ThemeModeNotifier _themeNotifier;

  Future<void> _onLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final userName = await _storage.getUserName();
      final isLoggedIn = await _storage.isLoggedIn();
      final savedLocale = await LocaleService.loadLocale(_storage);
      final themeMode = await _storage.getThemeMode();
      final hapticEnabled = await _storage.getHapticEnabled();
      emit(state.copyWith(
        userName: userName,
        isLoggedIn: isLoggedIn,
        locale: savedLocale,
        themeMode: themeMode ?? ThemeMode.system,
        hapticEnabled: hapticEnabled,
        status: SettingsStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(status: SettingsStatus.fail));
    }
  }

  Future<void> _onLogoutRequested(
    SettingsLogoutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _storage.setAccessToken(null);
    await _storage.setUserName(null);
    await _storage.setLoggedIn(false);
    emit(state.copyWith(
      userName: null,
      isLoggedIn: false,
    ));
  }

  Future<void> _onLanguageToggled(
    SettingsLanguageToggled event,
    Emitter<SettingsState> emit,
  ) async {
    //* Haptic from SettingsTile
    final newLocale = LocaleService.toggleLocale(event.currentLocale);
    await LocaleService.saveLocale(newLocale, _storage);
    emit(state.copyWith(locale: newLocale));
  }

  Future<void> _onThemeChanged(
    SettingsThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    //* Haptic from SettingsThemeTile
    await _themeNotifier.setThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onHapticToggled(
    SettingsHapticToggled event,
    Emitter<SettingsState> emit,
  ) async {
    //* Light tap before disabling (so user feels it one last time)
    AppHaptic.lightTap();
    await _storage.setHapticEnabled(event.enabled);
    AppHaptic.setEnabled(event.enabled);
    emit(state.copyWith(hapticEnabled: event.enabled));
  }
}
