import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/custom_text_form_field.dart';
import '../../../../core/localization/locale_keys.g.dart';

/// Username, password fields and forgot password link.
class LoginFormSection extends StatefulWidget {
  const LoginFormSection({
    super.key,
    this.usernameController,
    this.passwordController,
    this.onForgotPassword,
  });

  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  final VoidCallback? onForgotPassword;

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextFormField(
          controller: widget.usernameController,
          labelKey: LocaleKeys.auth_username,
          hintKey: LocaleKeys.auth_enterUsername,
          prefixIcon: Icon(
            Icons.person_outline,
            size: 20.r,
            color: colorScheme.onSurfaceVariant,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        SizedBox(height: 20.h),
        CustomTextFormField(
          controller: widget.passwordController,
          labelKey: LocaleKeys.auth_password,
          hintKey: LocaleKeys.auth_enterPassword,
          obscureText: _obscurePassword,
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 20.r,
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              size: 20.r,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        SizedBox(height: 8.h),
        //* Forgot password link
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: widget.onForgotPassword,
            child: Text(
              LocaleKeys.auth_forgotPassword.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF059669),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
