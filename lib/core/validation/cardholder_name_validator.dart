import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for cardholder name
class CardholderNameValidator {
  const CardholderNameValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_cardholderNameRequired.tr();
    }

    final trimmedValue = value.trim();

    // Check minimum length
    if (trimmedValue.length < 3) {
      return LocaleKeys.validation_cardholderNameMinLength.tr();
    }

    // Check if contains at least letters
    if (!RegExp(r'[a-zA-Z]').hasMatch(trimmedValue)) {
      return LocaleKeys.validation_cardholderNameInvalid.tr();
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(trimmedValue)) {
      return LocaleKeys.validation_cardholderNameInvalid.tr();
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'cardholderName': error} : null;
  }

  /// Legacy method for backward compatibility
  CardholderNameValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return CardholderNameValidationResult(error);
  }
}

/// Result wrapper for legacy compatibility
class CardholderNameValidationResult {
  final String? message;
  const CardholderNameValidationResult(this.message);
}
