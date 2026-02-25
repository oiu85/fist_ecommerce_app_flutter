import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for card CVV/CVC code
class CardCvvValidator {
  const CardCvvValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_cardCvvRequired.tr();
    }

    final valueStr = value.trim();
    
    // Check if only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(valueStr)) {
      return LocaleKeys.validation_cardCvvInvalid.tr();
    }

    // Check length (3 or 4 digits)
    if (valueStr.length < 3 || valueStr.length > 4) {
      return LocaleKeys.validation_cardCvvLength.tr();
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'cardCvv': error} : null;
  }

  /// Legacy method for backward compatibility
  CardCvvValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return CardCvvValidationResult(error);
  }
}

/// Result wrapper for legacy compatibility
class CardCvvValidationResult {
  final String? message;
  const CardCvvValidationResult(this.message);
}
