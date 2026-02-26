import 'package:equatable/equatable.dart';

/// Immutable state for the product details screen.
final class ProductDetailsState extends Equatable {
  const ProductDetailsState({
    this.quantity = 1,
    this.showButtonsOnContent = false,
    this.minQuantity = 1,
    this.maxQuantity,
  });

  final int quantity;
  final bool showButtonsOnContent;
  final int minQuantity;
  final int? maxQuantity;

  ProductDetailsState copyWith({
    int? quantity,
    bool? showButtonsOnContent,
    int? minQuantity,
    int? maxQuantity,
  }) =>
      ProductDetailsState(
        quantity: quantity ?? this.quantity,
        showButtonsOnContent: showButtonsOnContent ?? this.showButtonsOnContent,
        minQuantity: minQuantity ?? this.minQuantity,
        maxQuantity: maxQuantity ?? this.maxQuantity,
      );

  @override
  List<Object?> get props => [quantity, showButtonsOnContent, minQuantity, maxQuantity];
}
