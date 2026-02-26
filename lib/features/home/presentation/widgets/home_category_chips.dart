import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/category_chip.dart';
import '../../../../gen/assets.gen.dart';

import 'home_category_grid.dart';

//* Layout mode for category display: row (horizontal chips) or grid (cards).
enum CategoryLayoutStyle { row, grid }

@immutable
class HomeCategoryItem {
  const HomeCategoryItem({required this.id, required this.label, this.labelIsLocaleKey = false});

  final String id;
  final String label;
  final bool labelIsLocaleKey;
}

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    this.layoutStyle = CategoryLayoutStyle.row,
    this.onLayoutToggle,
  });

  final List<HomeCategoryItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final CategoryLayoutStyle layoutStyle;

  /// button is shown in the section header.
  final VoidCallback? onLayoutToggle;

  @override
  Widget build(BuildContext context) {
    return layoutStyle == CategoryLayoutStyle.row
        ? _buildRowLayout(context)
        : HomeCategoryGrid(
            categories: categories,
            selectedIndex: selectedIndex,
            onCategorySelected: onCategorySelected,
            onLayoutToggle: onLayoutToggle,
            layoutStyle: layoutStyle,
          );
  }

  /// Row layout: horizontal scroll of chips with layout toggle as overlay.
  Widget _buildRowLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      child: SizedBox(
        height: 55.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                top: 4.h,
                left: 20.w,
                right: onLayoutToggle != null ? 52.w : 20.w,
                bottom: 0,
              ),
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = index == selectedIndex;
                return CategoryChip(
                  label: category.label,
                  labelIsLocaleKey: category.labelIsLocaleKey,
                  selected: isSelected,
                  onTap: () => onCategorySelected(index),
                );
              },
            ),
            if (onLayoutToggle != null)
              Positioned(
                top: 0,
                right: 12.w,
                child: IconButton(
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
                  onPressed: onLayoutToggle,
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.r, 40.r),
                    padding: EdgeInsets.zero,
                    backgroundColor: colorScheme.surface,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

@Deprecated('Use HomeCategorySection with layoutStyle: CategoryLayoutStyle.row')
class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final List<HomeCategoryItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  @override
  Widget build(BuildContext context) => HomeCategorySection(
    categories: categories,
    selectedIndex: selectedIndex,
    onCategorySelected: onCategorySelected,
    layoutStyle: CategoryLayoutStyle.row,
  );
}
