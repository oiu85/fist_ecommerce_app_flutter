import 'package:reactive_forms/reactive_forms.dart' hide EmailValidator;
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';
import 'email_validator.dart';
import 'phone_validator.dart';

/// Validator for email or phone number field
/// 
/// Validates that:
/// - Field is not empty
/// - Value is either a valid email or a valid phone number
class EmailOrPhoneValidator {
  const EmailOrPhoneValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_emailRequired.tr();
    }

    final trimmedValue = value.trim();
    
    // Try email validation first
    final emailValidator = const EmailValidator();
    final emailError = emailValidator(trimmedValue);
    
    // If email is valid, return null
    if (emailError == null) {
      return null;
    }
    
    // Try phone validation
    final phoneValidator = const PhoneValidator();
    final phoneError = phoneValidator(trimmedValue);
    
    // If phone is valid, return null
    if (phoneError == null) {
      return null;
    }
    
    // Neither email nor phone is valid
    // Return a generic error message
    return LocaleKeys.validation_emailInvalid.tr();
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'emailOrPhone': error} : null;
  }

  /// Legacy method for backward compatibility
  EmailOrPhoneValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return EmailOrPhoneValidationResult(error);
  }

  /// Check if value is email or phone (static helper)
  static bool isValidEmailOrPhone(String value) {
    if (value.trim().isEmpty) return false;
    
    // Check if it's a valid email
    if (EmailValidator.isValidEmail(value.trim())) {
      return true;
    }
    
    // Check if it's a valid phone (digits only, 9-10 digits)
    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (RegExp(r'^[0-9]+$').hasMatch(cleanedPhone)) {
      if (cleanedPhone.startsWith('0')) {
        return cleanedPhone.length == 10;
      } else {
        return cleanedPhone.length == 9;
      }
    }
    
    return false;
  }
}

/// Result wrapper for legacy compatibility
class EmailOrPhoneValidationResult {
  final String? message;
  const EmailOrPhoneValidationResult(this.message);
}
