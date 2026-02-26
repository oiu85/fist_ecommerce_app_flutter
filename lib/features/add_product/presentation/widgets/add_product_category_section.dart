import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/category_chip.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../gen/assets.gen.dart';
import '../../../home/presentation/widgets/category_card.dart';
import '../../../home/presentation/widgets/home_category_chips.dart';

//* Add-product-specific category section: transparent background, toggle in its own row.
class AddProductCategorySection extends StatelessWidget {
  const AddProductCategorySection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.layoutStyle,
    required this.onCategorySelected,
    required this.onLayoutToggle,
  });

  final List<HomeCategoryItem> categories;
  final int selectedIndex;
  final CategoryLayoutStyle layoutStyle;
  final ValueChanged<int> onCategorySelected;
  final VoidCallback onLayoutToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //* Toggle button — own row, right-aligned
        SizedBox(
          height: 40.h,
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                AppHaptic.selection();
                onLayoutToggle();
              },
              icon: (layoutStyle == CategoryLayoutStyle.row
                      ? Assets.images.icons.category
                      : Assets.images.icons.listRow)
                  .svg(
                width: 22.r,
                height: 22.r,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              style: IconButton.styleFrom(
                minimumSize: Size(40.r, 40.r),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ),
        //* Category content — chips (row) or grid, transparent
        if (layoutStyle == CategoryLayoutStyle.row)
          _buildRowLayout(context)
        else
          _buildGridLayout(context),
      ],
    );
  }

  Widget _buildRowLayout(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 4.h, bottom: 0),
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
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final cardWidth = (availableWidth - 12.w) / 2;
          return Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(categories.length, (index) {
              final category = categories[index];
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
          );
        },
      ),
    );
  }
}
