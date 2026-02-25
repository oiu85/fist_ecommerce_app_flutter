import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for credit/debit card numbers
/// Validates using Luhn algorithm and basic length checks
class CardNumberValidator {
  const CardNumberValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_cardNumberRequired.tr();
    }

    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return LocaleKeys.validation_cardNumberInvalid.tr();
    }

    // Check length (13-19 digits for most cards)
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return LocaleKeys.validation_cardNumberLength.tr();
    }

    // Luhn algorithm validation
    if (!_luhnCheck(cleanNumber)) {
      return LocaleKeys.validation_cardNumberInvalid.tr();
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'cardNumber': error} : null;
  }

  /// Legacy method for backward compatibility
  CardNumberValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return CardNumberValidationResult(error);
  }

  /// Luhn algorithm to validate card number
  bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }
}

/// Result wrapper for legacy compatibility
class CardNumberValidationResult {
  final String? message;
  const CardNumberValidationResult(this.message);
}

/// Format card number with spaces (4 digits groups)
String formatCardNumber(String value) {
  final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
  final buffer = StringBuffer();

  for (int i = 0; i < cleanNumber.length; i++) {
    if (i > 0 && i % 4 == 0) {
      buffer.write(' ');
    }
    buffer.write(cleanNumber[i]);
  }

  return buffer.toString();
}
