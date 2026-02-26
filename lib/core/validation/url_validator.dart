import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../localization/locale_keys.g.dart';

//* Basic URL validator — required, valid URL pattern.
class UrlValidator {
  const UrlValidator();

  static final RegExp _urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.addProduct_validation_imageUrlRequired.tr();
    }
    final trimmed = value.trim();
    if (!_urlRegex.hasMatch(trimmed)) {
      return LocaleKeys.addProduct_validation_urlInvalid.tr();
    }
    return null;
  }

  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'url': error} : null;
  }

  static bool isValid(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    return _urlRegex.hasMatch(value.trim());
  }
}
