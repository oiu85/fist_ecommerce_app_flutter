import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../localization/locale_keys.g.dart';

//* Validator for description field — required non-empty (e.g. product description).
class DescriptionValidator {
  final int minLength;

  const DescriptionValidator({this.minLength = 1});

  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.addProduct_validation_descriptionRequired.tr();
    }
    if (value.trim().length < minLength) {
      return LocaleKeys.addProduct_validation_descriptionRequired.tr();
    }
    return null;
  }

  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'description': error} : null;
  }

  static bool isValid(String? value, {int minLength = 1}) {
    if (value == null || value.trim().isEmpty) return false;
    return value.trim().length >= minLength;
  }
}
