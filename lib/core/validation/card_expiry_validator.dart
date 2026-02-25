import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for card expiration date (MM/YY format)
class CardExpiryValidator {
  const CardExpiryValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_cardExpiryRequired.tr();
    }

    // Remove spaces and slashes
    final cleanValue = value.replaceAll(RegExp(r'[\s/]'), '');

    // Check if only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
      return LocaleKeys.validation_cardExpiryInvalid.tr();
    }

    // Check length (MMYY = 4 digits)
    if (cleanValue.length != 4) {
      return LocaleKeys.validation_cardExpiryInvalid.tr();
    }

    final month = int.parse(cleanValue.substring(0, 2));
    final year = int.parse(cleanValue.substring(2, 4));

    // Validate month (01-12)
    if (month < 1 || month > 12) {
      return LocaleKeys.validation_cardExpiryInvalidMonth.tr();
    }

    // Check if card is expired
    final now = DateTime.now();
    final currentYear = now.year % 100; // Get last 2 digits of year
    final currentMonth = now.month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return LocaleKeys.validation_cardExpiryExpired.tr();
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'cardExpiry': error} : null;
  }

  /// Legacy method for backward compatibility
  CardExpiryValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return CardExpiryValidationResult(error);
  }
}

/// Result wrapper for legacy compatibility
class CardExpiryValidationResult {
  final String? message;
  const CardExpiryValidationResult(this.message);
}

/// Format expiry date as MM/YY
String formatCardExpiry(String value) {
  final cleanValue = value.replaceAll(RegExp(r'[\s/]'), '');
  
  if (cleanValue.length <= 2) {
    return cleanValue;
  }

  return '${cleanValue.substring(0, 2)}/${cleanValue.substring(2)}';
}
