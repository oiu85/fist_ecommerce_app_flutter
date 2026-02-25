import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';

class AvatarWithInfo extends StatelessWidget {
  const AvatarWithInfo({
    super.key,
    this.imageUrl,
    this.imageProvider,
    this.titleKey,
    this.title,
    this.subtitleKey,
    this.subtitle,
    this.onTap,
    this.avatarSize,
    this.spacing,
    this.borderWidth,
    this.borderColor,
  }) : assert(
          imageUrl != null || imageProvider != null,
          'Either imageUrl or imageProvider must be provided.',
        ),
        assert(
          titleKey != null || title != null,
          'Either titleKey or title must be provided.',
        ),
        assert(
          subtitleKey != null || subtitle != null,
          'Either subtitleKey or subtitle must be provided.',
        );

  final String? imageUrl;
  final ImageProvider? imageProvider;
  final String? titleKey;
  final String? title;
  final String? subtitleKey;
  final String? subtitle;
  final VoidCallback? onTap;
  final double? avatarSize;
  final double? spacing;
  final double? borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    //* Main Row Container
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* Avatar Container
          Container(
            width: avatarSize ?? 42.w,
            height: avatarSize ?? 42.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: borderWidth ?? 2.w,
                color: borderColor ?? colorScheme.primary,
              ),
            ),
            child: ClipOval(
              child: imageProvider != null
                  ? Image(
                      image: imageProvider!,
                      width: avatarSize ?? 42.w,
                      height: avatarSize ?? 42.h,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageUrl!,
                      width: avatarSize ?? 42.w,
                      height: avatarSize ?? 42.h,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(width: spacing ?? 11.w),
          //* Info Column
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Title Text
              AppText(
                titleKey ?? title!,
                translation: titleKey != null,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              //* Subtitle Text
              AppText(
                subtitleKey ?? subtitle!,
                translation: subtitleKey != null,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

