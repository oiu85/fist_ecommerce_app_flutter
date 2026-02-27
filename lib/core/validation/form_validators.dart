
library;

export 'email_validator.dart';
export 'email_or_phone_validator.dart';
export 'password_validator.dart';
export 'confirm_password_validator.dart';
export 'name_validator.dart';
export 'phone_validator.dart';
export 'otp_validator.dart';
export 'country_validator.dart';
export 'card_number_validator.dart';
export 'card_expiry_validator.dart';
export 'card_cvv_validator.dart';
export 'cardholder_name_validator.dart';
export 'donation_amount_validator.dart';
export 'price_validator.dart';
export 'product_name_validator.dart';
export 'url_validator.dart';
export 'username_validator.dart';

/// Common validation utilities
class ValidationUtils {
  /// Check if a string is empty or null
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Check if a string contains only digits
  static bool isDigitsOnly(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  /// Check if a string contains only letters and spaces
  static bool isLettersAndSpacesOnly(String value) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
  }

  /// Check if a string contains only Arabic letters and spaces
  static bool isArabicLettersAndSpacesOnly(String value) {
    return RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(value);
  }

  /// Remove all non-digit characters from a string
  static String removeNonDigits(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Remove all spaces and dashes from a string
  static String removeSpacesAndDashes(String value) {
    return value.replaceAll(RegExp(r'[\s\-]'), '');
  }
}
