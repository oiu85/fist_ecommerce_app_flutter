import 'package:equatable/equatable.dart';

import '../../../../core/status/bloc_status.dart';
import '../../domain/entities/product.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_product_view_header.dart';

//* Home screen state — products, categories, selected filter, UI preferences, status.
//? All logic in BLoC; no setState in UI.

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    this.products,
    this.categories,
    this.selectedCategory,
    this.errorMessage,
    this.categoryLayoutStyle = CategoryLayoutStyle.row,
    this.productViewStyle = ProductViewStyle.grid,
    this.isSearchMode = false,
    this.isRefreshing = false,
  });

  final BlocStatus status;
  final List<Product>? products;
  final List<String>? categories;
  final String? selectedCategory;
  final String? errorMessage;
  final CategoryLayoutStyle categoryLayoutStyle;
  final ProductViewStyle productViewStyle;
  final bool isSearchMode;
  final bool isRefreshing;

  factory HomeState.initial() => const HomeState(
        status: BlocStatus.initial(),
        products: null,
        categories: null,
        selectedCategory: null,
        errorMessage: null,
        categoryLayoutStyle: CategoryLayoutStyle.row,
        productViewStyle: ProductViewStyle.grid,
        isSearchMode: false,
        isRefreshing: false,
      );

  /// Status for UiHelperStatus / when pattern (exposes BlocStatus).
  BlocStatus get homeStatus => status;

  HomeState copyWith({
    BlocStatus? status,
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
    String? errorMessage,
    CategoryLayoutStyle? categoryLayoutStyle,
    ProductViewStyle? productViewStyle,
    bool? isSearchMode,
    bool? isRefreshing,
    bool clearErrorMessage = false,
  }) =>
      HomeState(
        status: status ?? this.status,
        products: products ?? this.products,
        categories: categories ?? this.categories,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
        categoryLayoutStyle: categoryLayoutStyle ?? this.categoryLayoutStyle,
        productViewStyle: productViewStyle ?? this.productViewStyle,
        isSearchMode: isSearchMode ?? this.isSearchMode,
        isRefreshing: isRefreshing ?? this.isRefreshing,
      );

  @override
  List<Object?> get props => [
        status,
        products,
        categories,
        selectedCategory,
        errorMessage,
        categoryLayoutStyle,
        productViewStyle,
        isSearchMode,
        isRefreshing,
      ];
}
