import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for OTP code field
/// 
/// Validates that:
/// - OTP is not empty
/// - OTP contains only digits
/// - OTP is exactly 4 digits
/// - For design/testing: accepts "0000" as valid default code
class OtpValidator {
  const OtpValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.login_wrongCode.tr();
    }

    final otpCode = value.trim();

    // Check if it contains only digits
    final digitRegex = RegExp(r'^[0-9]+$');
    if (!digitRegex.hasMatch(otpCode)) {
      return LocaleKeys.login_wrongCode.tr();
    }

    // Check if it's exactly 4 digits
    if (otpCode.length != 4) {
      return LocaleKeys.login_wrongCode.tr();
    }

    // For design/testing: "0000" is valid
    // In production, you would verify against backend
    if (otpCode == "0000") {
      return null;
    }

    // TODO: Add backend verification here
    // For now, accept any 4-digit code
    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'otp': error} : null;
  }

  /// Legacy method for backward compatibility
  OtpValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return OtpValidationResult(error);
  }

  /// Validate OTP code directly
  static bool isValidOtp(String code) {
    if (code.isEmpty || code.length != 4) return false;
    final digitRegex = RegExp(r'^[0-9]+$');
    return digitRegex.hasMatch(code);
  }
}

/// Result wrapper for legacy compatibility
class OtpValidationResult {
  final String? message;
  const OtpValidationResult(this.message);
}
