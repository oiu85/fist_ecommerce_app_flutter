import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

/// Product view style: grid (2 columns) or list (horizontal rows).
enum ProductViewStyle { grid, list }

/// Header row for product section: title + grid/list toggle.
class HomeProductViewHeader extends StatelessWidget {
  const HomeProductViewHeader({
    super.key,
    required this.viewStyle,
    required this.onViewToggle,
  });

  final ProductViewStyle viewStyle;
  final VoidCallback onViewToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            LocaleKeys.home_products,
            translation: true,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: appColors?.primaryNavy ?? colorScheme.onSurface,
            ),
            maxLines: 1,
            isAutoScale: true,
          ),
          IconButton(
            onPressed: () {
              AppHaptic.selection();
              onViewToggle();
            },
            icon: (viewStyle == ProductViewStyle.grid
                    ? Assets.images.icons.listRow
                    : Assets.images.icons.category)
                .svg(
              width: 22.r,
              height: 22.r,
              colorFilter: ColorFilter.mode(
                colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            style: IconButton.styleFrom(
              minimumSize: Size(40.r, 40.r),
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
              backgroundColor: colorScheme.surface,
            ),
            tooltip: viewStyle == ProductViewStyle.grid
                ? 'Switch to list view'
                : 'Switch to grid view',
          ),
        ],
      ),
    );
  }
}
