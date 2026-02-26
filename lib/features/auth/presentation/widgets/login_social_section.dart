import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';

/// "Or" divider plus Google and Apple sign-in buttons.
class LoginSocialSection extends StatelessWidget {
  const LoginSocialSection({
    super.key,
    this.onGoogleSignIn,
    this.onAppleSignIn,
  });

  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //* Or separator
        Row(
          children: [
            Expanded(
              child: Divider(
                color: const Color(0xFFE2E8F0),
                thickness: 1,
                height: 1.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppText(
                LocaleKeys.auth_or,
                translation: true,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: const Color(0xFFE2E8F0),
                thickness: 1,
                height: 1.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        //* Continue with Google
        _LoginSocialButton(
          labelKey: LocaleKeys.auth_continueWithGoogle,
          icon: Icons.g_mobiledata_rounded,
          onTap: () {
            AppHaptic.lightTap();
            onGoogleSignIn?.call();
          },
        ),
        SizedBox(height: 12.h),
        //* Continue with Apple
        _LoginSocialButton(
          labelKey: LocaleKeys.auth_continueWithApple,
          icon: Icons.apple,
          onTap: () {
            AppHaptic.lightTap();
            onAppleSignIn?.call();
          },
        ),
      ],
    );
  }
}

class _LoginSocialButton extends StatelessWidget {
  const _LoginSocialButton({
    required this.labelKey,
    required this.icon,
    required this.onTap,
  });

  final String labelKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.w, color: colorScheme.outline),
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24.r, color: colorScheme.onSurface),
              SizedBox(width: 12.w),
              AppText(
                labelKey,
                translation: true,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
