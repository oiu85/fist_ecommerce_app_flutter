import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';

/// Validator for country field
///
/// Validates that a country has been selected
class CountryValidator {
  const CountryValidator();

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.login_validation_countryRequired.tr();
    }
    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'country': error} : null;
  }

  /// Legacy method for backward compatibility
  CountryValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return CountryValidationResult(error);
  }
}

/// Result wrapper for legacy compatibility
class CountryValidationResult {
  final String? message;
  const CountryValidationResult(this.message);
}
