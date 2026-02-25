import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';
import '../localization/locale_keys.g.dart';
import '../../gen/fonts.gen.dart';
import 'dialog_header.dart';
import 'dotted_divider.dart';

/// Reusable confirmation dialog component
/// Shows a confirmation dialog with customizable title, message, and actions
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  /// Show confirmation dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          maxWidth: 400.w,
        ),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Top Colored Bar
              Container(
                width: double.infinity,
                height: 8.h,
                decoration: BoxDecoration(
                  color: isDestructive ? colorScheme.primary : colorScheme.primary,
                ),
              ),

              //* Content
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w, top: 14.h, right: 15.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* Header
                        DialogHeader(
                          title: title.tr(),
                          iconColor: isDestructive ? colorScheme.error : colorScheme.primary,
                          showAddIcon: false,
                        ),

                        SizedBox(height: 19.h),

                        //* Dotted Divider
                        DottedDivider(
                          color: isDestructive ? colorScheme.error : colorScheme.primary,
                        ),

                        SizedBox(height: 24.h),

                        //* Message
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: AppText(
                            message,
                            translation: true,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: 14.sp,
                              fontFamily: FontFamily.sora,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ),

              //* Action Buttons
              Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 16.h, top: 8.h),
                child: Row(
                  children: [
                    //* Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel ?? () => Navigator.of(context).pop(false),
                        child: Container(
                          height: 48.h,
                          decoration: ShapeDecoration(
                            color: colorScheme.surfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Center(
                            child: AppText(
                              cancelText ?? LocaleKeys.app_cancel,
                              translation: true,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 14.sp,
                                fontFamily: FontFamily.sora,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    //* Confirm Button
                    Expanded(
                      child: GestureDetector(
                        onTap: onConfirm ?? () => Navigator.of(context).pop(true),
                        child: Container(
                          height: 48.h,
                          decoration: ShapeDecoration(
                            color: isDestructive ? colorScheme.error : colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Center(
                            child: AppText(
                              confirmText ?? 'Confirm',
                              translation: true,
                              style: textTheme.bodyMedium?.copyWith(
                                color: isDestructive ? colorScheme.onError : colorScheme.onPrimary,
                                fontSize: 14.sp,
                                fontFamily: FontFamily.sora,
                                fontWeight: FontWeight.w500,
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