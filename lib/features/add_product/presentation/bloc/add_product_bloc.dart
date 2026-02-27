import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/add_product_use_case.dart';
import '../../../../core/status/bloc_status.dart';
import 'add_product_event.dart';
import 'add_product_state.dart';

//* BLoC for Add Product form — categories, submit, navigation.
//? Uses AddProductUseCase and GetCategoriesUseCase; no direct API calls.

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc({
    required AddProductUseCase addProductUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _addProductUseCase = addProductUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        super(AddProductState.initial()) {
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
    on<CategorySelected>(_onCategorySelected);
    on<SubmitAddProduct>(_onSubmitAddProduct);
  }

  final AddProductUseCase _addProductUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onLoadCategoriesRequested(
    LoadCategoriesRequested event,
    Emitter<AddProductState> emit,
  ) async {
    emit(state.copyWith(status: const BlocStatus.loading(), clearErrorMessage: true));
    final result = await _getCategoriesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.fail(error: failure.message),
        errorMessage: failure.message,
        //! Fallback to API-style categories if GET /categories fails
        categories: const [
          'electronics',
          'jewelery',
          "men's clothing",
          "women's clothing",
        ],
      )),
      (apiCategories) => emit(state.copyWith(
        status: const BlocStatus.success(),
        categories: apiCategories,
        clearErrorMessage: true,
      )),
    );
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
  }

  Future<void> _onSubmitAddProduct(
    SubmitAddProduct event,
    Emitter<AddProductState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatus.loading(),
      clearCreatedProduct: true,
      clearErrorMessage: true,
    ));
    final result = await _addProductUseCase(event.input);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.fail(error: failure.message),
        errorMessage: failure.message,
      )),
      (product) => emit(state.copyWith(
        status: const BlocStatus.success(),
        createdProduct: product,
      )),
    );
  }
}
