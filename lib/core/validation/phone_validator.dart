import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for phone number field
/// 
/// Validates that:
/// - Phone number is not empty
/// - Phone number contains only digits
/// - Phone number is 10 digits if starts with 0, or 9 digits otherwise
class PhoneValidator {
  const PhoneValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.login_validation_phoneRequired.tr();
    }

    // Remove spaces and dashes for validation
    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-]'), '');

    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return LocaleKeys.login_validation_phoneDigitsOnly.tr();
    }

    // Check length based on whether it starts with 0
    if (cleanedPhone.startsWith('0')) {
      if (cleanedPhone.length != 10) {
        return LocaleKeys.login_validation_phoneLengthWith0.tr();
      }
    } else {
      if (cleanedPhone.length != 9) {
        return LocaleKeys.login_validation_phoneLengthWithout0.tr();
      }
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'phone': error} : null;
  }

  /// Legacy method for backward compatibility
  PhoneValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return PhoneValidationResult(error);
  }
}

/// Result wrapper for legacy compatibility
class PhoneValidationResult {
  final String? message;
  const PhoneValidationResult(this.message);
}

