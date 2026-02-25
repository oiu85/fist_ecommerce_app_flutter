import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for name field
/// 
/// Validates that:
/// - Name is not empty
/// - Name contains only letters and spaces (English or Arabic)
/// - Name is at least 2 characters long
class NameValidator {
  final int minLength;

  const NameValidator({this.minLength = 2});

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.login_validation_nameRequired.tr();
    }

    final stringValue = value.trim();

    if (stringValue.length < minLength) {
      return LocaleKeys.login_validation_nameMinLength.tr();
    }

    // Allow both English and Arabic letters with spaces
    final nameRegex = RegExp(r"^[a-zA-Z\u0600-\u06FF\s]+$");
    if (!nameRegex.hasMatch(stringValue)) {
      return LocaleKeys.login_validation_nameLettersOnly.tr();
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'name': error} : null;
  }

  /// Legacy method for backward compatibility
  NameValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return NameValidationResult(error);
  }

  /// Static helper to validate name
  static bool isValidName(String name, {int minLength = 2}) {
    if (name.trim().isEmpty || name.trim().length < minLength) return false;
    final nameRegex = RegExp(r"^[a-zA-Z\u0600-\u06FF\s]+$");
    return nameRegex.hasMatch(name.trim());
  }
}

/// Result wrapper for legacy compatibility
class NameValidationResult {
  final String? message;
  const NameValidationResult(this.message);
}
