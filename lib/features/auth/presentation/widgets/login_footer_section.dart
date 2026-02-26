import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/routing/app_routes.dart';

/// Create account prompt and Privacy / Terms links.
class LoginFooterSection extends StatelessWidget {
  const LoginFooterSection({
    super.key,
    this.onCreateAccountTap,
  });

  final VoidCallback? onCreateAccountTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //* Don't have account + Create account
        AppText(
          LocaleKeys.auth_dontHaveAccount,
          translation: true,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () {
            AppHaptic.lightTap();
            if (onCreateAccountTap != null) {
              onCreateAccountTap!();
            } else {
              context.push(AppRoutes.signup);
            }
          },
          child: AppText(
            LocaleKeys.auth_createAccount,
            translation: true,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 32.h),
        //* Privacy Policy • Terms of Service
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FooterLink(
              labelKey: LocaleKeys.auth_privacyPolicy,
              onTap: () {
                AppHaptic.lightTap();
                //! TODO: Navigate to privacy policy when route exists
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                '•',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
            _FooterLink(
              labelKey: LocaleKeys.auth_termsOfService,
              onTap: () {
                AppHaptic.lightTap();
                //! TODO: Navigate to terms when route exists
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.labelKey, required this.onTap});

  final String labelKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Text(
        labelKey.tr(),
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
