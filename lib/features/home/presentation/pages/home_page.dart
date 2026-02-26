import 'package:flutter/material.dart';

import '../../../../core/shared/app_scaffold.dart';
import '../../../../mock_data/home_mock_data.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_page_app_bar.dart';
import '../widgets/home_product_grid.dart';


class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.cartCount = 0,
    this.onSearchTap,
    this.onCartTap,
  });

  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  CategoryLayoutStyle _categoryLayout = CategoryLayoutStyle.row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold.custom(
      backgroundColor: theme.colorScheme.surface,
      appBar: HomePageAppBar(
        cartCount: widget.cartCount,
        onSearchTap: widget.onSearchTap,
        onCartTap: widget.onCartTap,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeCategorySection(
            categories: mockHomeCategories,
            selectedIndex: _selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() => _selectedCategoryIndex = index);
            },
            layoutStyle: _categoryLayout,
            onLayoutToggle: () {
              setState(() {
                _categoryLayout = _categoryLayout == CategoryLayoutStyle.row
                    ? CategoryLayoutStyle.grid
                    : CategoryLayoutStyle.row;
              });
            },
          ),
          Expanded(
            child: HomeProductGrid(
              items: defaultHomeProductGridItems,
              onProductTap: (_) {
                //! TODO: Navigate to product detail when implemented.
              },
            ),
          ),
        ],
      ),
    );
  }
}
