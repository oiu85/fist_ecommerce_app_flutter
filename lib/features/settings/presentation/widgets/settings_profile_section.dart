//* Profile section for Settings page — avatar/username or login prompt.
//* If not logged in: login icon + "Login" (translated), tappable. If logged in: avatar + username.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

class SettingsProfileSection extends StatelessWidget {
  const SettingsProfileSection({
    super.key,
    required this.isLoggedIn,
    this.username,
    this.imageUrl,
    this.onLoginTap,
  });

  final bool isLoggedIn;
  final String? username;
  final String? imageUrl;
  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final borderColor = appColors?.borderColor ?? colorScheme.outline;

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: !isLoggedIn && onLoginTap != null
              ? () {
                  AppHaptic.selection();
                  onLoginTap!();
                }
              : null,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: colorScheme.primary.withValues(alpha: 0.04),
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
                if (isLoggedIn) ...[
                  _ProfileAvatar(imageUrl: imageUrl),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppText(
                      username ?? 'User',
                      translation: false,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            appColors?.primaryNavy ?? colorScheme.onSurface,
                      ),
                    ),
                  ),
                ] else ...[
                  Assets.images.icons.loginIcon.svg(
                    width: 32.r,
                    height: 32.r,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppText(
                      LocaleKeys.auth_signIn.tr(),
                      translation: false,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            appColors?.primaryNavy ?? colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (onLoginTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.r,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ],
            ),
          ),
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
