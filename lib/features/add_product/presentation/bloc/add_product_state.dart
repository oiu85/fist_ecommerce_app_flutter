import 'package:equatable/equatable.dart';

import '../../../../core/status/bloc_status.dart';
import '../../../home/domain/entities/product.dart';

//* Add product form state — categories, selected category, submit status.
//? All logic in BLoC; UI reacts to state.

class AddProductState extends Equatable {
  const AddProductState({
    required this.status,
    this.categories = const [],
    this.selectedCategoryIndex = 0,
    this.createdProduct,
    this.errorMessage,
  });

  final BlocStatus status;
  /// API category strings (e.g. electronics, men's clothing). Map to HomeCategoryItem in UI.
  final List<String> categories;
  final int selectedCategoryIndex;
  /// Set on submit success; used for navigation to product details.
  final Product? createdProduct;
  final String? errorMessage;

  factory AddProductState.initial() => const AddProductState(
        status: BlocStatus.initial(),
        categories: [],
        selectedCategoryIndex: 0,
        createdProduct: null,
        errorMessage: null,
      );

  /// Status for UiHelperStatus / when pattern (exposes BlocStatus).
  BlocStatus get addProductStatus => status;

  AddProductState copyWith({
    BlocStatus? status,
    List<String>? categories,
    int? selectedCategoryIndex,
    Product? createdProduct,
    String? errorMessage,
    bool clearCreatedProduct = false,
    bool clearErrorMessage = false,
  }) =>
      AddProductState(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
        createdProduct: clearCreatedProduct ? null : (createdProduct ?? this.createdProduct),
        errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [
        status,
        categories,
        selectedCategoryIndex,
        createdProduct,
        errorMessage,
      ];
}
