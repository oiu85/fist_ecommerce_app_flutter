import 'package:flutter/material.dart';

import '../storage/app_storage_service.dart';

/// Locale service - handles locale toggling and persistence
class LocaleService {
  LocaleService._();

  /// Toggle between English and Arabic
  static Locale toggleLocale(Locale current) {
    return current.languageCode == 'en' 
        ? const Locale('ar') 
        : const Locale('en');
  }

  /// Get default locale (English)
  static Locale getDefaultLocale() {
    return const Locale('en');
  }

  /// Save locale to storage
  static Future<void> saveLocale(
    Locale locale,
    AppStorageService storage,
  ) async {
    await storage.setLocale(locale);
  }

  /// Load locale from storage, returns default if not found
  static Future<Locale> loadLocale(AppStorageService storage) async {
    final savedLocale = await storage.getLocale();
    return savedLocale ?? getDefaultLocale();
  }
}

