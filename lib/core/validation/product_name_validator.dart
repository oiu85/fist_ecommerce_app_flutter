import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../localization/locale_keys.g.dart';

//* Validator for product name — required, min length.
class ProductNameValidator {
  final int minLength;

  const ProductNameValidator({this.minLength = 1});

  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.addProduct_validation_productNameRequired.tr();
    }
    if (value.trim().length < minLength) {
      return LocaleKeys.addProduct_validation_productNameRequired.tr();
    }
    return null;
  }

  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'productName': error} : null;
  }

  static bool isValid(String? value, {int minLength = 1}) {
    if (value == null || value.trim().isEmpty) return false;
    return value.trim().length >= minLength;
  }
}
