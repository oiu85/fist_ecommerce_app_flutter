import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../../mock_data/home_mock_data.dart';
import '../../../../mock_data/product_details_mock_data.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_category_view_header.dart';
import '../widgets/home_page_app_bar.dart';
import '../widgets/home_product_grid.dart';
import '../widgets/home_product_list.dart';
import '../widgets/home_product_view_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.cartCount = 0, this.onSearchTap, this.onCartTap});

  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  CategoryLayoutStyle _categoryLayout = CategoryLayoutStyle.row;

  //* Product view: grid (2 columns) or list (horizontal rows)
  ProductViewStyle _productViewStyle = ProductViewStyle.grid;

  //* Search mode state: show search field in app bar, hide logo + title
  bool _isSearchMode = false;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (_isSearchMode) {
        _searchController.clear();
        _searchFocusNode.requestFocus();
      } else {
        _searchFocusNode.unfocus();
      }
    });
  }

  void _onSearchClosed() {
    setState(() {
      _isSearchMode = false;
      _searchController.clear();
      _searchFocusNode.unfocus();
    });
  }

  //! TODO: implement search results when backend/API is ready
  void _onSearchQueryChanged(String query) {
    //* Search results handling - placeholder for future implementation
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold.custom(
      backgroundColor: theme.colorScheme.surface,
      appBar: HomePageAppBar(
        cartCount: widget.cartCount,
        onSearchTap: widget.onSearchTap ?? _toggleSearchMode,
        onCartTap: widget.onCartTap,
        isSearchMode: _isSearchMode,
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onSearchClosed: _onSearchClosed,
        onSearchQueryChanged: _onSearchQueryChanged,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // ——— Category section: header (like products) + chips row or grid ———
          SliverToBoxAdapter(
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeCategoryViewHeader(
                    layoutStyle: _categoryLayout,
                    onViewToggle: () {
                      setState(() {
                        _categoryLayout =
                            _categoryLayout == CategoryLayoutStyle.row
                                ? CategoryLayoutStyle.grid
                                : CategoryLayoutStyle.row;
                      });
                    },
                  ),
                  ColoredBox(
                    color: theme.colorScheme.surface,
                    child: AnimatedSection(
                      sectionIndex: 0,
                      child: AnimatedSwitcher(
                        duration: AnimationConstants.standard,
                        switchInCurve: AnimationConstants.entranceCurve,
                        switchOutCurve: AnimationConstants.exitCurve,
                        child: HomeCategorySection(
                          key: ValueKey(_categoryLayout),
                          categories: mockHomeCategories,
                          selectedIndex: _selectedCategoryIndex,
                          onCategorySelected: (index) {
                            setState(() => _selectedCategoryIndex = index);
                          },
                          layoutStyle: _categoryLayout,
                          //* Toggle lives in header; no inline button
                          onLayoutToggle: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ——— Product section: header + grid or list ———
          SliverToBoxAdapter(
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainerHighest,
              child: HomeProductViewHeader(
                viewStyle: _productViewStyle,
                onViewToggle: () {
                  setState(() {
                    _productViewStyle =
                        _productViewStyle == ProductViewStyle.grid
                            ? ProductViewStyle.list
                            : ProductViewStyle.grid;
                  });
                },
              ),
            ),
          ),
          if (_productViewStyle == ProductViewStyle.grid)
            buildHomeProductGridSliver(
              context,
              items: defaultHomeProductGridItems,
              onProductTap: (item) {
                context.push(
                  AppRoutes.productDetails,
                  extra: payloadFromHomeItem(item),
                );
              },
            )
          else
            buildHomeProductListSliver(
              context,
              items: defaultHomeProductGridItems,
              onProductTap: (item) {
                context.push(
                  AppRoutes.productDetails,
                  extra: payloadFromHomeItem(item),
                );
              },
            ),
        ],
      ),
    );
  }
}
