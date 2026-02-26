import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/status/ui_helper.dart';
import '../../../../mock_data/home_mock_data.dart';
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
  });

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = state.categories != null
        ? categoriesFromApiWithAll(state.categories!)
        : <HomeCategoryItem>[];
    final selectedIndex = _selectedIndexFromState(state, categories);
    final productItems =
        (state.products ?? []).map(productToGridItem).toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshHome());
        await context.read<HomeBloc>().stream
            .where((s) => !s.status.isLoading())
            .first;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeCategoryViewHeader(
                    layoutStyle: state.categoryLayoutStyle,
                    onViewToggle: () =>
                        context.read<HomeBloc>().add(const CategoryLayoutToggled()),
                  ),
                  ColoredBox(
                    color: theme.colorScheme.surface,
                    child: RepaintBoundary(
                      child: HomeCategorySection(
                        key: ValueKey(state.categoryLayoutStyle),
                        categories: categories,
                        selectedIndex: selectedIndex,
                        onCategorySelected: (index) {
                          final categoryId = categories[index].id;
                          context.read<HomeBloc>().add(
                                CategorySelected(
                                  categoryId == 'all' ? null : categoryId,
                                ),
                              );
                        },
                        layoutStyle: state.categoryLayoutStyle,
                        onLayoutToggle: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: HomeProductViewHeader(
                viewStyle: state.productViewStyle,
                onViewToggle: () =>
                    context.read<HomeBloc>().add(const ProductViewStyleToggled()),
              ),
            ),
          ),
          if (productItems.isEmpty)
            const SliverFillRemaining(
              child: NoDataWidget(message: 'No products found'),
            )
          else if (state.productViewStyle == ProductViewStyle.grid)
            buildHomeProductGridSliver(
              context,
              items: productItems,
              onProductTapWithIndex: (item, index) {
                final product = state.products![index];
                context.push(
                  AppRoutes.productDetails,
                  extra: payloadFromProduct(product),
                );
              },
            )
          else
            buildHomeProductListSliver(
              context,
              items: productItems,
              onProductTapWithIndex: (item, index) {
                final product = state.products![index];
                context.push(
                  AppRoutes.productDetails,
                  extra: payloadFromProduct(product),
                );
              },
            ),
        ],
      ),
    );
  }

  static int _selectedIndexFromState(
    HomeState state,
    List<HomeCategoryItem> categories,
  ) {
    if (state.selectedCategory == null || state.selectedCategory == 'all') {
      return 0;
    }
    final idx = categories.indexWhere((c) => c.id == state.selectedCategory);
    return idx >= 0 ? idx : 0;
  }
}
