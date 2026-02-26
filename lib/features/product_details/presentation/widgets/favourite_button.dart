import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: colorScheme.primary.withValues(alpha: 0.2),
        highlightColor: colorScheme.primary.withValues(alpha: 0.1),
        child: Container(
          width: 48.r,
          height: 48.r,
          decoration: ShapeDecoration(
            color: colorScheme.surface,
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
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
