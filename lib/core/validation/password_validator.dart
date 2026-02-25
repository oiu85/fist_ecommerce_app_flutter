import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for password field
/// 
/// Validates that:
/// - Password is not empty
/// - Password is at least 8 characters long
/// - Password contains at least one letter and one number (optional, can be customized)
class PasswordValidator {
  final int minLength;
  final bool requireUpperCase;
  final bool requireLowerCase;
  final bool requireNumber;
  final bool requireSpecialChar;

  const PasswordValidator({
    this.minLength = 8,
    this.requireUpperCase = false,
    this.requireLowerCase = false,
    this.requireNumber = false,
    this.requireSpecialChar = false,
  });

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_passwordRequired.tr();
    }

    final password = value;

    if (password.length < minLength) {
      return LocaleKeys.validation_passwordMinLength.tr(namedArgs: {'minLength': minLength.toString()});
    }

    if (requireUpperCase && !password.contains(RegExp(r'[A-Z]'))) {
      return LocaleKeys.validation_passwordRequireUpperCase.tr();
    }

    if (requireLowerCase && !password.contains(RegExp(r'[a-z]'))) {
      return LocaleKeys.validation_passwordRequireLowerCase.tr();
    }

    if (requireNumber && !password.contains(RegExp(r'[0-9]'))) {
      return LocaleKeys.validation_passwordRequireNumber.tr();
    }

    if (requireSpecialChar && !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return LocaleKeys.validation_passwordRequireSpecialChar.tr();
    }

    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'password': error} : null;
  }

  /// Legacy method for backward compatibility
  PasswordValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return PasswordValidationResult(error);
  }

  /// Get password strength (weak, medium, strong)
  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;
    if (password.length < 6) return PasswordStrength.weak;

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    if (strength <= 2) return PasswordStrength.weak;
    if (strength <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
}

/// Result wrapper for legacy compatibility
class PasswordValidationResult {
  final String? message;
  const PasswordValidationResult(this.message);
}

enum PasswordStrength {
  empty,
  weak,
  medium,
  strong,
}
