import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/category_chip.dart';
import '../../../../core/localization/locale_keys.g.dart';


@immutable
class HomeCategoryItem {
  const HomeCategoryItem({
    required this.id,
    required this.labelLocaleKey,
  });

  final String id;
  final String labelLocaleKey;
}

List<HomeCategoryItem> get mockHomeCategories => const <HomeCategoryItem>[
  HomeCategoryItem(id: 'all', labelLocaleKey: LocaleKeys.home_categoryAll),
  HomeCategoryItem(
    id: 'electronics',
    labelLocaleKey: LocaleKeys.home_categoryElectronics,
  ),
  HomeCategoryItem(
    id: 'jewelery',
    labelLocaleKey: LocaleKeys.home_categoryJewelery,
  ),
  HomeCategoryItem(
    id: 'mens_clothing',
    labelLocaleKey: LocaleKeys.home_categoryMensClothing,
  ),
  HomeCategoryItem(
    id: 'womens_clothing',
    labelLocaleKey: LocaleKeys.home_categoryWomensClothing,
  ),
];


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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //* Fixed height so horizontal ListView has bounded height and chips are visible.
    const double rowHeight = 55;

    return Container(
      width: double.infinity,
      color: colorScheme.surface,
      child: SizedBox(
        height: rowHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(top: 4.h, right: 20.w, left: 20.w, bottom: 0),
          itemCount: categories.length,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = index == selectedIndex;
            return CategoryChip(
              label: category.labelLocaleKey,
              labelIsLocaleKey: true,
              selected: isSelected,
              onTap: () => onCategorySelected(index),
            );
          },
        ),
      ),
    );
  }
}
