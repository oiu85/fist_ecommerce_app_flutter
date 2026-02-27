import 'package:flutter/material.dart';

import '../../../../core/component/app_filled_button.dart';
import '../../../../core/localization/locale_keys.g.dart';

class LoginSignInButton extends StatelessWidget {
  const LoginSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppFilledButton(
      labelKey: LocaleKeys.auth_signIn,
      onPressed: isLoading ? null : onPressed,
      width: double.infinity,
    );
  }
}
