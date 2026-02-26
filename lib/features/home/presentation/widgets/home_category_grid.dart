import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 12.h),
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
                    icon: (layoutStyle == CategoryLayoutStyle.row
                            ? Assets.images.icons.category
                            : Assets.images.icons.listRow)
                        .svg(width: 22.r, height: 22.r),
                    onPressed: onLayoutToggle,
                    style: IconButton.styleFrom(minimumSize: Size(40.r, 40.r), padding: EdgeInsets.zero),
                  ),
                ],
              ),
            ),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(categories.length, (index) {
              final category = categories[index];
              final cardWidth = (MediaQuery.sizeOf(context).width - 20.w * 2 - 12.w) / 2;
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
        ],
      ),
    );
  }
}
