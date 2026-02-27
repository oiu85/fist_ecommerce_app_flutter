import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/component/empty_state_widgets.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../mock_data/home_mock_data.dart';
import '../../domain/entities/product.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../mappers/home_product_mapper.dart';
import 'home_category_chips.dart';
import 'home_category_view_header.dart';
import 'home_product_grid.dart';
import 'home_product_list.dart';
import 'home_product_view_header.dart';

//* Home success content: categories, products, pull-to-refresh.
//? Extracted from HomePage for separation of concerns.

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.state,
    this.categorySectionKey,
    this.productAreaKey,
  });

  final HomeState state;
  final GlobalKey? categorySectionKey;
  final GlobalKey? productAreaKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = state.categories != null ? categoriesFromApiWithAll(state.categories!) : <HomeCategoryItem>[];
    final selectedIndex = _selectedIndexFromState(state, categories);
    //* Client-side search: filter by title, category, or description (no API).
    final displayProducts = _filterProductsByQuery(state.products ?? [], state.searchQuery);
    final productItems = displayProducts.map(productToGridItem).toList();
    final searchQuery = state.searchQuery.trim();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshHome());
        await context.read<HomeBloc>().stream.where((s) => !s.status.isLoading()).first;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: _wrapSectionEntrance(
                context,
                sectionIndex: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeCategoryViewHeader(
                      layoutStyle: state.categoryLayoutStyle,
                      onViewToggle: () => context.read<HomeBloc>().add(const CategoryLayoutToggled()),
                    ),
                    _wrapWithKey(
                      categorySectionKey,
                      ColoredBox(
                        color: theme.colorScheme.surface,
                        child: RepaintBoundary(
                          child: HomeCategorySection(
                            key: ValueKey(state.categoryLayoutStyle),
                            categories: categories,
                            selectedIndex: selectedIndex,
                            onCategorySelected: (index) {
                              final categoryId = categories[index].id;
                              //* "All" → null so BLoC refetches all products without passing category to API.
                              context.read<HomeBloc>().add(
                                    CategorySelected(categoryId == 'all' ? null : categoryId),
                                  );
                            },
                            layoutStyle: state.categoryLayoutStyle,
                            onLayoutToggle: null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: _wrapSectionEntrance(
                context,
                sectionIndex: 1,
                child: HomeProductViewHeader(
                  viewStyle: state.productViewStyle,
                  onViewToggle: () => context.read<HomeBloc>().add(const ProductViewStyleToggled()),
                ),
              ),
            ),
          ),
          if (productItems.isEmpty)
            SliverFillRemaining(
              child: searchQuery.isEmpty
                  ? const EmptyHomeContentWidget()
                  : EmptySearchResultWidget(
                      messageKey: LocaleKeys.home_noResultsFor,
                      namedArgs: {'query': searchQuery},
                    ),
            )
          else if (state.productViewStyle == ProductViewStyle.grid)
            buildHomeProductGridSliver(
              context,
              items: productItems,
              searchHighlight: searchQuery.isEmpty ? null : searchQuery,
              firstItemKey: productAreaKey,
              onProductTapWithIndex: (item, index) {
                final product = displayProducts[index];
                context.push(AppRoutes.productDetails, extra: payloadFromProduct(product));
              },
            )
          else
            buildHomeProductListSliver(
              context,
              items: productItems,
              searchHighlight: searchQuery.isEmpty ? null : searchQuery,
              firstItemKey: productAreaKey,
              onProductTapWithIndex: (item, index) {
                final product = displayProducts[index];
                context.push(AppRoutes.productDetails, extra: payloadFromProduct(product));
              },
            ),
        ],
      ),
    );
  }

  static int _selectedIndexFromState(HomeState state, List<HomeCategoryItem> categories) {
    if (state.selectedCategory == null || state.selectedCategory == 'all') {
      return 0;
    }
    final idx = categories.indexWhere((c) => c.id == state.selectedCategory);
    return idx >= 0 ? idx : 0;
  }

  /// Filters products by query (title, category, description); case-insensitive.
  static List<Product> _filterProductsByQuery(List<Product> products, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return products;
    return products
        .where(
          (p) =>
              p.title.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q),
        )
        .toList();
  }

  /// Wraps [child] with KeyedSubtree when [key] is non-null (for coach tour).
  static Widget _wrapWithKey(GlobalKey? key, Widget child) {
    if (key == null) return child;
    return KeyedSubtree(key: key, child: child);
  }

  /// Wraps [child] with section entrance animation when animations are enabled.
  static Widget _wrapSectionEntrance(BuildContext context, {required int sectionIndex, required Widget child}) {
    if (AnimationConstants.shouldReduceMotion(context)) return child;
    return child.sectionEntrance(sectionIndex: sectionIndex);
  }
}
