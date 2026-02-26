import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* Storage keys for SharedPreferences

class StorageKeys {
  StorageKeys._();

  static const String onboardingSkipped = 'onboarding_skipped';
  static const String accessToken = 'access_token';
  static const String userName = 'user_name';
  static const String locale = 'locale';
  static const String themeMode = 'theme_mode';
  static const String hapticEnabled = 'haptic_enabled';
}

abstract class AppStorageService {
  Future<bool> isOnboardingSkipped();

  Future<void> setOnboardingSkipped(bool value);

  Future<String?> getAccessToken();

  Future<void> setAccessToken(String? token);

  Future<String?> getUserName();

  Future<void> setUserName(String? name);

  Future<void> clearAll();

  Future<Locale?> getLocale();

  Future<void> setLocale(Locale locale);

  Future<ThemeMode?> getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);

  Future<bool> getHapticEnabled();

  Future<void> setHapticEnabled(bool value);
}

//? SharedPreferences implementation of AppStorageService
//* this class is responsible for storing and retrieving data from SharedPreferences.

class SharedPreferencesStorageService implements AppStorageService {
  final SharedPreferences _prefs;
  
  SharedPreferencesStorageService(this._prefs);

  
  @override
  Future<bool> isOnboardingSkipped() async {
    return _prefs.getBool(StorageKeys.onboardingSkipped) ?? false;
  }
  
  @override
  Future<void> setOnboardingSkipped(bool value) async {
    await _prefs.setBool(StorageKeys.onboardingSkipped, value);
  }

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(StorageKeys.accessToken);
  }
  
  @override
  Future<void> setAccessToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _prefs.remove(StorageKeys.accessToken);
    } else {
      await _prefs.setString(StorageKeys.accessToken, token);
    }
  }

  @override
  Future<String?> getUserName() async {
    return _prefs.getString(StorageKeys.userName);
  }
  
  @override
  Future<void> setUserName(String? name) async {
    if (name == null || name.isEmpty) {
      await _prefs.remove(StorageKeys.userName);
    } else {
      await _prefs.setString(StorageKeys.userName, name);
    }
  }
  
  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  @override
  Future<Locale?> getLocale() async {
    final localeString = _prefs.getString(StorageKeys.locale);
    if (localeString == null) {
      return null;
    }
    return Locale(localeString);
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(StorageKeys.locale, locale.languageCode);
  }

  @override
  Future<ThemeMode?> getThemeMode() async {
    final index = _prefs.getInt(StorageKeys.themeMode);
    if (index == null) return null;
    if (index >= 0 && index <= 2) {
      return ThemeMode.values[index];
    }
    return null;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(StorageKeys.themeMode, mode.index);
  }

  @override
  Future<bool> getHapticEnabled() async {
    return _prefs.getBool(StorageKeys.hapticEnabled) ?? true;
  }

  @override
  Future<void> setHapticEnabled(bool value) async {
    await _prefs.setBool(StorageKeys.hapticEnabled, value);
  }
}

