import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../gen/assets.gen.dart';


class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    //* Dark mode: semi-opaque white for visibility over dark hero image
    final bgColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.22)
        : colorScheme.surface;
    final iconColor = theme.brightness == Brightness.dark
        ? colorScheme.onSurface
        : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed != null
            ? () {
                AppHaptic.lightTap();
                onPressed!();
              }
            : null,
        customBorder: const CircleBorder(),
        splashColor: iconColor.withValues(alpha: 0.2),
        highlightColor: iconColor.withValues(alpha: 0.1),
        child: Container(
          width: 48.r,
          height: 48.r,
          decoration: ShapeDecoration(
            color: bgColor,
            shape: const CircleBorder(),
            shadows: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.12),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.08),
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Assets.images.icons.heart.svg(
              width: 22.r,
              height: 22.r,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
