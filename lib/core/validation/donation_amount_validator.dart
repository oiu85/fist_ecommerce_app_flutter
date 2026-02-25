import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';


class DonationAmountValidator {
  final double? maxAmount;
  
  const DonationAmountValidator({this.maxAmount});

  String? call(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validation_donationAmountRequired.tr();
    }

    final amount = double.tryParse(value.trim());
    
    if (amount == null) {
      return LocaleKeys.validation_donationAmountInvalid.tr();
    }

    if (amount <= 0) {
      return LocaleKeys.validation_donationAmountMustBePositive.tr();
    }

    if (maxAmount != null && amount > maxAmount!) {
      return '${LocaleKeys.validation_donationAmountExceedsRemaining.tr()} (\$${maxAmount!.toStringAsFixed(0)})';
    }

    return null;
  }

 
  Map<String, dynamic>? reactive(AbstractControl<dynamic> control) {
    final error = call(control.value?.toString());
    return error != null ? {'donationAmount': error} : null;
  }

  DonationAmountValidationResult resolve(Object? value) {
    final error = call(value?.toString());
    return DonationAmountValidationResult(error);
  }

  
  static bool isValidAmount(String amount, {double? maxAmount}) {
    if (amount.isEmpty) return false;
    
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null || parsedAmount <= 0) return false;
    
    if (maxAmount != null && parsedAmount > maxAmount) return false;
    
    return true;
  }
}


class DonationAmountValidationResult {
  final String? message;
  const DonationAmountValidationResult(this.message);
}

