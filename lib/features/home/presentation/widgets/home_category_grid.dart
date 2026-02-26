import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    const crossAxisCount = 2;
    final crossSpacing = 12.w;
    final mainSpacing = 12.h;
    final horizontalPadding = 20.w;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final totalHorizontalPadding = horizontalPadding * 2;
    final availableWidth = screenWidth - totalHorizontalPadding - crossSpacing;
    final cardWidth = availableWidth / crossAxisCount;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 8.h,
        bottom: 12.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onLayoutToggle != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      layoutStyle == CategoryLayoutStyle.row
                          ? Icons.grid_view_rounded
                          : Icons.view_agenda_rounded,
                      size: 22.r,
                    ),
                    onPressed: onLayoutToggle,
                    style: IconButton.styleFrom(
                      minimumSize: Size(40.r, 40.r),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          Wrap(
            spacing: crossSpacing,
            runSpacing: mainSpacing,
            children: List.generate(categories.length, (index) {
              final category = categories[index];
              final isSelected = index == selectedIndex;
              return SizedBox(
                width: cardWidth,
                child: CategoryCard(
                  label: category.label,
                  labelIsLocaleKey: category.labelIsLocaleKey,
                  selected: isSelected,
                  width: cardWidth,
                  height: 72.h,
                  onTap: () => onCategorySelected(index),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
