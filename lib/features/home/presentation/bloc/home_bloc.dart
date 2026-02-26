import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/failure.dart';
import '../../../../core/status/bloc_status.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_product_view_header.dart';
import 'home_event.dart';
import 'home_state.dart';

//* Home BLoC — all home logic; products, categories, UI preferences.
//? One-way flow: Event → BLoC → State. No setState in UI.

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        super(HomeState.initial()) {
    on<LoadHome>(_onLoadHome);
    on<CategorySelected>(_onCategorySelected);
    on<RefreshHome>(_onRefreshHome);
    on<CategoryLayoutToggled>(_onCategoryLayoutToggled);
    on<ProductViewStyleToggled>(_onProductViewStyleToggled);
    on<SearchModeToggled>(_onSearchModeToggled);
    on<SearchClosed>(_onSearchClosed);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<BottomNavIndexChanged>(_onBottomNavIndexChanged);
  }

  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    await _loadHome(emit, selectedCategory: null, isRefreshing: false);
  }

  Future<void> _onCategorySelected(
    CategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    await _loadHome(emit, selectedCategory: event.categoryName, isRefreshing: state.products != null);
  }

  Future<void> _onRefreshHome(RefreshHome event, Emitter<HomeState> emit) async {
    await _loadHome(emit, selectedCategory: state.selectedCategory, isRefreshing: true);
  }

  void _onCategoryLayoutToggled(CategoryLayoutToggled event, Emitter<HomeState> emit) {
    final next = state.categoryLayoutStyle == CategoryLayoutStyle.row
        ? CategoryLayoutStyle.grid
        : CategoryLayoutStyle.row;
    emit(state.copyWith(categoryLayoutStyle: next));
  }

  void _onProductViewStyleToggled(ProductViewStyleToggled event, Emitter<HomeState> emit) {
    final next = state.productViewStyle == ProductViewStyle.grid
        ? ProductViewStyle.list
        : ProductViewStyle.grid;
    emit(state.copyWith(productViewStyle: next));
  }

  void _onSearchModeToggled(SearchModeToggled event, Emitter<HomeState> emit) {
    emit(state.copyWith(isSearchMode: !state.isSearchMode));
  }

  void _onSearchClosed(SearchClosed event, Emitter<HomeState> emit) {
    emit(state.copyWith(isSearchMode: false, searchQuery: ''));
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onBottomNavIndexChanged(BottomNavIndexChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedBottomNavIndex: event.index));
  }

  Future<void> _loadHome(
    Emitter<HomeState> emit, {
    required String? selectedCategory,
    required bool isRefreshing,
  }) async {
    emit(state.copyWith(
      status: const BlocStatus.loading(),
      isRefreshing: isRefreshing,
      clearErrorMessage: true,
    ));

    //* Fetch categories only on initial load; reuse on refresh/category switch
    final isInitialLoad = state.categories == null;
    Either<Failure, List<String>>? categoriesResult;
    if (isInitialLoad) {
      categoriesResult = await _getCategoriesUseCase();
    }

    final productsResult = await _getProductsUseCase(
      category: selectedCategory,
    );

    final categoriesList = categoriesResult != null
        ? categoriesResult.fold(
            (f) => state.categories ?? [],
            (c) => c,
          )
        : (state.categories ?? []);

    productsResult.fold(
      (failure) {
        emit(state.copyWith(
          status: BlocStatus.fail(error: failure.message),
          errorMessage: failure.message,
          selectedCategory: selectedCategory,
          categories: categoriesList,
          isRefreshing: false,
        ));
      },
      (products) {
        emit(state.copyWith(
          status: const BlocStatus.success(),
          products: products,
          categories: categoriesList,
          selectedCategory: selectedCategory,
          isRefreshing: false,
          clearErrorMessage: true,
        ));
      },
    );
  }
}
