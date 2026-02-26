import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../gen/assets.gen.dart';

import 'category_card.dart';
import 'home_category_chips.dart';

class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    this.onLayoutToggle,
    this.layoutStyle = CategoryLayoutStyle.row,
  });

  final List<HomeCategoryItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final VoidCallback? onLayoutToggle;
  final CategoryLayoutStyle layoutStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final horizontalPadding = 20.w;
    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 4.h, bottom: 12.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(top: onLayoutToggle != null ? 8.h : 0),
            child: Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              //* Category count from API is small (<10); List.generate is acceptable.
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                final cardWidth = (MediaQuery.sizeOf(context).width - horizontalPadding * 2 - 12.w) / 2;
                return SizedBox(
                  width: cardWidth,
                  child: CategoryCard(
                    label: category.label,
                    labelIsLocaleKey: category.labelIsLocaleKey,
                    selected: index == selectedIndex,
                    width: cardWidth,
                    height: 72.h,
                    onTap: () => onCategorySelected(index),
                  ),
                );
              }),
            ),
          ),
          if (onLayoutToggle != null)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  AppHaptic.selection();
                  onLayoutToggle!();
                },
                icon: (layoutStyle == CategoryLayoutStyle.row
                        ? Assets.images.icons.category
                        : Assets.images.icons.listRow)
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
                  backgroundColor: colorScheme.surface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
