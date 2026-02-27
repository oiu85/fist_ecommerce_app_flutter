import 'package:dartz/dartz.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/network/network_client.dart';

//* Remote cart data source (FakeStoreAPI).
//? Used for simulation only; API does not persist. Fire-and-forget.

abstract class CartRemoteDataSource {
  Future<Either<NetworkFailure, CartApiResponse>> getCart(int id);
  Future<Either<NetworkFailure, List<CartApiResponse>>> getAllCarts();
  Future<Either<NetworkFailure, CartApiResponse>> createCart(
    int userId,
    List<CartProductItem> products,
  );
  Future<Either<NetworkFailure, CartApiResponse>> updateCart(
    int id,
    int userId,
    List<CartProductItem> products,
  );
  Future<Either<NetworkFailure, void>> deleteCart(int id);
}

/// API request/response model for cart (productId + quantity).
class CartProductItem {
  const CartProductItem({required this.productId, required this.quantity});
  final int productId;
  final int quantity;
  Map<String, dynamic> toJson() =>
      {'productId': productId, 'quantity': quantity};
}

/// API cart response (id, userId, products).
class CartApiResponse {
  const CartApiResponse({
    required this.id,
    required this.userId,
    required this.products,
  });
  final int id;
  final int userId;
  final List<CartProductItem> products;
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this._client);
  final NetworkClient _client;

  @override
  Future<Either<NetworkFailure, CartApiResponse>> getCart(int id) async {
    final result = await _client.get(ApiConfig.cartByIdPath(id));
    return result.fold(
      Left.new,
      (r) {
        final data = r.data;
        if (data == null) return Left(const NetworkFailure(message: 'Null response'));
        return _parseCartResponse(data);
      },
    );
  }

  @override
  Future<Either<NetworkFailure, List<CartApiResponse>>> getAllCarts() async {
    final result = await _client.get(ApiConfig.cartsPath);
    return result.fold(
      Left.new,
      (r) {
        final data = r.data;
        if (data is! List) {
          return Left(const NetworkFailure(message: 'Invalid carts response'));
        }
        final list = <CartApiResponse>[];
        for (final e in data) {
          if (e is Map<String, dynamic>) {
            final parsed = _parseCartResponse(e);
            parsed.fold((_) {}, list.add);
          }
        }
        return Right(list);
      },
    );
  }

  @override
  Future<Either<NetworkFailure, CartApiResponse>> createCart(
    int userId,
    List<CartProductItem> products,
  ) async {
    final body = {
      'userId': userId,
      'products': products.map((e) => e.toJson()).toList(),
    };
    final result = await _client.post(ApiConfig.cartsPath, data: body);
    return result.fold(
      Left.new,
      (r) {
        final data = r.data;
        if (data == null) return Left(const NetworkFailure(message: 'Null response'));
        return _parseCartResponse(data);
      },
    );
  }

  @override
  Future<Either<NetworkFailure, CartApiResponse>> updateCart(
    int id,
    int userId,
    List<CartProductItem> products,
  ) async {
    final body = {
      'userId': userId,
      'products': products.map((e) => e.toJson()).toList(),
    };
    final result = await _client.put(ApiConfig.cartByIdPath(id), data: body);
    return result.fold(
      Left.new,
      (r) {
        final data = r.data;
        if (data == null) return Left(const NetworkFailure(message: 'Null response'));
        return _parseCartResponse(data);
      },
    );
  }

  @override
  Future<Either<NetworkFailure, void>> deleteCart(int id) async {
    final result = await _client.delete(ApiConfig.cartByIdPath(id));
    return result.fold(Left.new, (_) => const Right(null));
  }

  Either<NetworkFailure, CartApiResponse> _parseCartResponse(
    Map<String, dynamic> data,
  ) {
    try {
      final id = data['id'] as int? ?? 0;
      final userId = data['userId'] as int? ?? 0;
      final productsRaw = data['products'];
      final products = <CartProductItem>[];
      if (productsRaw is List) {
        for (final p in productsRaw) {
          if (p is Map<String, dynamic>) {
            final productId = p['productId'] as int? ?? p['id'] as int? ?? 0;
            final quantity = p['quantity'] as int? ?? 1;
            products.add(CartProductItem(productId: productId, quantity: quantity));
          }
        }
      }
      return Right(CartApiResponse(id: id, userId: userId, products: products));
    } catch (e) {
      return Left(NetworkFailure(message: 'Parse error: $e'));
    }
  }
}
