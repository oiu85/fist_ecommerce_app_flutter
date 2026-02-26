import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../localization/locale_keys.g.dart';

//* Validator for price fields — required, numeric, non-negative.
class PriceValidator {
  const PriceValidator();

  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.addProduct_validation_priceRequired.tr();
    }

    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return LocaleKeys.addProduct_validation_priceInvalid.tr();
    }
    if (amount < 0) {
      return LocaleKeys.addProduct_validation_priceInvalid.tr();
    }
    return null;
  }

  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'price': error} : null;
  }

  static bool isValid(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final n = double.tryParse(value.trim());
    return n != null && n >= 0;
  }
}
