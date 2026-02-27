import 'package:equatable/equatable.dart';

import '../../../../core/status/bloc_status.dart';
import '../../../home/domain/entities/product.dart';

//* Cart BLoC state.
//? Items include resolved Product for display; status for UI.

/// Display-ready cart item with product info.
class CartDisplayItem extends Equatable {
  const CartDisplayItem({
    required this.productId,
    required this.quantity,
    this.product,
  });

  final int productId;
  final int quantity;
  final Product? product;

  double get unitPrice => product?.price ?? 0.0;
  double get lineTotal => unitPrice * quantity;
  String get title => product?.title ?? 'Product #$productId';
  String get imageUrl => product?.imageUrl ?? '';

  @override
  List<Object?> get props => [productId, quantity, product];
}

class CartState extends Equatable {
  const CartState({
    required this.status,
    this.items = const [],
    this.itemCount = 0,
    this.errorMessage,
  });

  final BlocStatus status;
  final List<CartDisplayItem> items;
  final int itemCount;
  final String? errorMessage;

  static CartState initial() => CartState(
        status: const BlocStatus.initial(),
        items: const [],
        itemCount: 0,
      );


  BlocStatus get cartStatus => status;

  CartState copyWith({
    BlocStatus? status,
    List<CartDisplayItem>? items,
    int? itemCount,
    String? errorMessage,
    bool clearError = false,
  }) =>
      CartState(
        status: status ?? this.status,
        items: items ?? this.items,
        itemCount: itemCount ?? this.itemCount,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [status, items, itemCount, errorMessage];
}
