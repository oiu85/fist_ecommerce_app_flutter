import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fsit_flutter_task_ecommerce/core/localization/app_text.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';

class LoginInfoBanner extends StatelessWidget {
  const LoginInfoBanner({
    super.key,
    required this.onDismiss,
  });

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppColorExtension>();
    final infoBg = ext?.warningBackground ?? theme.colorScheme.tertiaryContainer;
    final infoFg = ext?.warning ?? theme.colorScheme.onTertiaryContainer;

    final banner = Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: infoBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: infoFg.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 24.r,
              color: infoFg,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText(
                isAutoScale: true,
                maxLines: 5,
                translation: true,
                LocaleKeys.auth_defaultLoginInfo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: infoFg,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, size: 20.r, color: infoFg),
              style: IconButton.styleFrom(
                padding: EdgeInsets.all(4.r),
                minimumSize: Size(32.r, 32.r),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
    return banner
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.5, end: 0, curve: Curves.easeOutCubic);
  }
}
