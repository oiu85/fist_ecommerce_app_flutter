import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/status/bloc_status.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/domain/repositories/product_repository.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

//* Cart BLoC — load, add, update, remove cart items.
//? Resolves products via IProductRepository for display.

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required ICartRepository cartRepository,
    required IProductRepository productRepository,
  })  : _cartRepository = cartRepository,
        _productRepository = productRepository,
        super(CartState.initial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<RemoveItem>(_onRemoveItem);
  }

  final ICartRepository _cartRepository;
  final IProductRepository _productRepository;

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: const BlocStatus.loading(), clearError: true));
    try {
      final items = await _cartRepository.getCartItems();
      final count = await _cartRepository.getItemCount();
      final displayItems = await _resolveProducts(items);
      emit(state.copyWith(
        status: const BlocStatus.success(),
        items: displayItems,
        itemCount: count,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BlocStatus.fail(error: e.toString()),
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.addOrUpdateItem(event.productId, event.quantity);
      add(const LoadCart());
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.updateQuantity(event.productId, event.quantity);
      add(const LoadCart());
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onRemoveItem(RemoveItem event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.removeItem(event.productId);
      add(const LoadCart());
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Resolves Product for each cart item (fetch all products, then map by id).
  Future<List<CartDisplayItem>> _resolveProducts(
    List<CartItemEntity> items,
  ) async {
    if (items.isEmpty) return [];
    final productIds = items.map((e) => e.productId).toSet().toList();
    final productMap = <int, Product>{};
    final productsResult = await _productRepository.getProducts();
    productsResult.fold(
      (_) {},
      (products) {
        for (final p in products) {
          if (productIds.contains(p.id)) productMap[p.id] = p;
        }
      },
    );
    for (final id in productIds) {
      if (productMap.containsKey(id)) continue;
      final single = await _productRepository.getProductById(id);
      single.fold((_) {}, (p) {
        if (p != null) productMap[id] = p;
      });
    }
    return items
        .map(
          (item) => CartDisplayItem(
            productId: item.productId,
            quantity: item.quantity,
            product: productMap[item.productId],
          ),
        )
        .toList();
  }
}
