import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';
import '../localization/locale_keys.g.dart';
import '../theme/app_color_extension.dart';
import 'app_filled_button.dart';

/// Exit confirmation dialog shown when the user attempts to exit the app
/// (e.g. via Android back button on the main container).
///
/// Returns `true` if the user confirms exit (app will close),
/// `false` if the user cancels.
class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  /// Shows the exit confirmation dialog.
  ///
  /// Returns `true` if user chose to exit (caller should call
  /// [SystemNavigator.pop]), `false` if cancelled.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const ExitDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 297.85.w),
        child: Container(
          width: 271.w,
          padding: EdgeInsets.all(20.w),
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            shadows: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.25),
                blurRadius: 38.78.r,
                offset: Offset(0, 19.39.h),
                spreadRadius: -9.31.r,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.21.h),
                    child: AppText(
                      LocaleKeys.exitDialog_title,
                      translation: true,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: appColors?.primaryNavy ?? colorScheme.onSurface,
                        fontSize: 15.51.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.08.w),
                    child: AppText(
                      LocaleKeys.exitDialog_subtitle,
                      translation: true,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 10.86.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppFilledButton(
                        labelKey: LocaleKeys.exitDialog_exit,
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        height: 44.h,
                        borderRadius: 10.r,
                      ),
                    ),
                    SizedBox(width: 9.31.w),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(false),
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: appColors?.componentBackground ??
                                  colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            alignment: Alignment.center,
                            child: AppText(
                              LocaleKeys.app_cancel,
                              translation: true,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12.41.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
