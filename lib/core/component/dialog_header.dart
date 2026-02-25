import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../localization/app_text.dart';

/// Reusable dialog header component
class DialogHeader extends StatelessWidget {
  const DialogHeader({
    super.key,
    this.title,
    this.titleKey,
    this.onClose,
    this.iconColor,
    this.showAddIcon = false,
  }) : assert(title != null || titleKey != null, 'Either title or titleKey must be provided');

  /// Title text (if translation is false)
  final String? title;

  /// Title localization key (if translation is true)
  final String? titleKey;
  final VoidCallback? onClose;

  /// Icon color (defaults to primary color)
  final Color? iconColor;

  /// Whether to show add icon instead of default users icon
  final bool showAddIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final iconColorValue = iconColor ?? colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //* Title with icon
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: showAddIcon
                    ? Assets.images.icons.addNew.svg(
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          iconColorValue,
                          BlendMode.srcIn,
                        ),
                      )
                    : Assets.images.icons.a2User.svg(
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          iconColorValue,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
              SizedBox(width: 8.w),
              AppText(
                titleKey ?? title ?? '',
                translation: titleKey != null,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 12.sp,
                  fontFamily: FontFamily.sora,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        //* Close button
        GestureDetector(
          onTap: onClose ?? () => Navigator.of(context).pop(),
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: ShapeDecoration(
              color: colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
            ),
            child: SvgPicture.asset(Assets.images.icons.closebutton.path),
          ),
        ),
      ],
    );
  }
}

