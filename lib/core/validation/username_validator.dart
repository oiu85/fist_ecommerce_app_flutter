import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../localization/locale_keys.g.dart';

//* Validator for login username field.
//? Required, min length; accepts alphanumeric + underscore (e.g. mor_2314).

class UsernameValidator {
  final int minLength;

  const UsernameValidator({this.minLength = 1});

  /// Validate for standard Form (returns String? for error message)
  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_required.tr();
    }
    if (value.trim().length < minLength) {
      return LocaleKeys.validation_required.tr();
    }
    return null;
  }

  /// Validate for reactive_forms (returns Map<String, dynamic>?)
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'username': error} : null;
  }
}
