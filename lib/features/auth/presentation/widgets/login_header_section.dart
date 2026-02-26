import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../gen/assets.gen.dart';

/// Login header: logo, app name, welcome subtitle.
class LoginHeaderSection extends StatelessWidget {
  const LoginHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //* Logo container with gradient and shadow
        RepaintBoundary(
          child: Container(
            width: 56.r,
            height: 56.r,
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(-0.35, 0.35),
                end: Alignment(0.35, 1.06),
                colors: [Color(0xFF10B981), Color(0xFF0D9488)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              shadows: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  blurRadius: 15.r,
                  offset: Offset(0, 10.h),
                ),
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  blurRadius: 6.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Center(
              child: Assets.images.icons.bag.svg(
                width: 24.r,
                height: 24.r,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        //* App name
        AppText(
          LocaleKeys.app_name,
          translation: true,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.5,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 5.h),
        //* Welcome subtitle
        AppText(
          LocaleKeys.auth_welcomeBack,
          translation: true,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
