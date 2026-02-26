//* Header row for category section — matches HomeProductViewHeader style.
//* Title + row/grid layout toggle.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

import 'home_category_chips.dart';

/// Header row for category section: title + row/grid toggle.
/// Mirrors [HomeProductViewHeader] layout and styling.
class HomeCategoryViewHeader extends StatelessWidget {
  const HomeCategoryViewHeader({super.key, required this.layoutStyle, required this.onViewToggle});

  final CategoryLayoutStyle layoutStyle;
  final VoidCallback onViewToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            LocaleKeys.home_categories,
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
            icon: (layoutStyle == CategoryLayoutStyle.row ? Assets.images.icons.category : Assets.images.icons.listRow)
                .svg(width: 22.r, height: 22.r, colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn)),
            style: IconButton.styleFrom(
              minimumSize: Size(40.r, 40.r),
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
              backgroundColor: colorScheme.surface,
            ),
            tooltip: layoutStyle == CategoryLayoutStyle.row ? 'Switch to grid view' : 'Switch to list view',
          ),
        ],
      ),
    );
  }
}
