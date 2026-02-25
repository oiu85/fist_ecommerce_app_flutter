import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for confirm password field
/// 
/// Validates that:
/// - Confirm password is not empty
/// - Confirm password matches the original password
class ConfirmPasswordValidator {
  final String originalPassword;

  const ConfirmPasswordValidator(this.originalPassword);

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_confirmPasswordRequired.tr();
    }

    if (value != originalPassword) {
      return LocaleKeys.validation_confirmPasswordMismatch.tr();
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'confirmPassword': error} : null;
  }

  /// Legacy method for backward compatibility
  ConfirmPasswordValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return ConfirmPasswordValidationResult(error);
  }

  /// Static helper to check if passwords match
  static bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword && password.isNotEmpty;
  }
}

/// Result wrapper for legacy compatibility
class ConfirmPasswordValidationResult {
  final String? message;
  const ConfirmPasswordValidationResult(this.message);
}
