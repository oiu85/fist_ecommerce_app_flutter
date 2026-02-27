import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsit_flutter_task_ecommerce/core/shared/app_scaffold.dart';

import '../../../../core/status/bloc_status.dart';
import '../../../../core/status/ui_helper.dart';
import '../../../../skeleton_features/skeleton_features.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_content.dart';
import '../widgets/home_page_app_bar.dart';

//* Home tab content; all logic in [HomeBloc]. Bloc provided by [MainContainerPage].

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.cartCount = 0,
    this.onSearchTap,
    this.onCartTap,
    this.searchKey,
    this.cartKey,
    this.appBarTitleKey,
    this.categorySectionKey,
    this.productAreaKey,
  });

  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;
  final GlobalKey? searchKey;
  final GlobalKey? cartKey;
  final GlobalKey? appBarTitleKey;
  final GlobalKey? categorySectionKey;
  final GlobalKey? productAreaKey;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //* UI controllers (Flutter primitives); focus/unfocus in BlocListener
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) => prev.isSearchMode != curr.isSearchMode,
      listener: (_, state) {
        if (state.isSearchMode) {
          _searchController.clear();
          _searchFocusNode.requestFocus();
        } else {
          _searchController.clear();
          _searchFocusNode.unfocus();
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.isRefreshing != curr.isRefreshing ||
            prev.isSearchMode != curr.isSearchMode ||
            prev.searchQuery != curr.searchQuery ||
            prev.products != curr.products ||
            prev.categories != curr.categories ||
            prev.selectedCategory != curr.selectedCategory ||
            prev.categoryLayoutStyle != curr.categoryLayoutStyle ||
            prev.productViewStyle != curr.productViewStyle ||
            (curr.status.isFail() && prev.homeStatus != curr.homeStatus),
        builder: (context, state) {
          return AppScaffold.custom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: HomePageAppBar(
              cartCount: widget.cartCount,
              onSearchTap: widget.onSearchTap ?? () => context.read<HomeBloc>().add(const SearchModeToggled()),
              onCartTap: widget.onCartTap,
              isSearchMode: state.isSearchMode,
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onSearchClosed: () => context.read<HomeBloc>().add(const SearchClosed()),
              onSearchQueryChanged: (query) => context.read<HomeBloc>().add(SearchQueryChanged(query)),
              searchKey: widget.searchKey,
              cartKey: widget.cartKey,
              appBarTitleKey: widget.appBarTitleKey,
            ),
            body: state.status.when<Widget>(
              //* MainContainerPage dispatches LoadHome on bloc creation; avoid duplicate fetch.
              initial: () => HomeSkeleton(status: state.status),
              loading: () => HomeSkeleton(status: state.status),
              success: () {
                if (state.isRefreshing) {
                  return HomeSkeleton(status: const BlocStatus.loading());
                }
                return HomeContent(
                  state: state,
                  categorySectionKey: widget.categorySectionKey,
                  productAreaKey: widget.productAreaKey,
                );
              },
              error: (_) => UiHelperStatus(
                state: state.homeStatus,
                onRetry: () => context.read<HomeBloc>().add(const RefreshHome()),
              ),
            ),
          );
        },
      ),
    );
  }
}
