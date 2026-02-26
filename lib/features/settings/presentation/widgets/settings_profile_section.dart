//* Profile section for Settings page — avatar with placeholder and username.
//* Uses app design tokens and CartItem-style tile pattern.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

/// Profile header with circular avatar (placeholder or network image) and username.
class SettingsProfileSection extends StatelessWidget {
  const SettingsProfileSection({
    super.key,
    required this.username,
    this.imageUrl,
  });

  final String username;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final borderColor = appColors?.borderColor ?? colorScheme.outline;

    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: ShapeDecoration(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.12),
              blurRadius: 2,
              offset: const Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            //* Profile image — placeholder or network
            _ProfileAvatar(imageUrl: imageUrl),
            SizedBox(width: 16.w),
            Expanded(
              child: AppText(
                username,
                translation: false,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appColors?.primaryNavy ?? colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final surfaceHighest = colorScheme.surfaceContainerHighest;
    final borderColor = appColors?.borderColor ?? colorScheme.outline;

    return Container(
      width: 64.r,
      height: 64.r,
      decoration: ShapeDecoration(
        color: surfaceHighest,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(9999.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999.r),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: 64.r,
                height: 64.r,
                errorBuilder: (context, error, stackTrace) =>
                    _PlaceholderIcon(theme: theme),
              )
            : _PlaceholderIcon(theme: theme),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    return Center(
      child: Assets.images.icons.profile.svg(
        width: 32.r,
        height: 32.r,
        colorFilter: ColorFilter.mode(
          colorScheme.onSurfaceVariant,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
