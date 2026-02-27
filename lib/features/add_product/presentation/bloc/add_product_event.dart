import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/create_product_input.dart';

//* Add product form events — load categories, submit product.

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object?> get props => [];
}

/// Load categories from API for form dropdown/chips.
class LoadCategoriesRequested extends AddProductEvent {
  const LoadCategoriesRequested();
}

/// User selected a category by index.
class CategorySelected extends AddProductEvent {
  const CategorySelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

/// User submitted the add product form.
class SubmitAddProduct extends AddProductEvent {
  const SubmitAddProduct(this.input);

  final CreateProductInput input;

  @override
  List<Object?> get props => [input];
}
