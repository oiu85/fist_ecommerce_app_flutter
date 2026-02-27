import 'package:dartz/dartz.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/network/network_client.dart';
import '../models/product_model.dart';

//* Remote data source for product API.
//? Uses NetworkClient only; returns Either for repository to map to domain Failure.

class ProductRemoteDataSource {
  ProductRemoteDataSource(this._client);

  final NetworkClient _client;

  /// Fetches all products.
  Future<Either<NetworkFailure, List<ProductModel>>> getProducts() async {
    final result = await _client.get(ApiConfig.productsPath);
    return result.fold(
      Left.new,
      (response) {
        final data = response.data;
        if (data is! List) {
          return Left(NetworkFailure(
            message: 'Invalid products response format',
          ));
        }
        try {
          final models = data
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(models);
        } catch (e) {
          return Left(NetworkFailure(message: 'Failed to parse products: $e'));
        }
      },
    );
  }

  /// Fetches product categories.
  Future<Either<NetworkFailure, List<String>>> getCategories() async {
    final result = await _client.get(ApiConfig.productsCategoriesPath);
    return result.fold(
      Left.new,
      (response) {
        final data = response.data;
        if (data is! List) {
          return Left(NetworkFailure(
            message: 'Invalid categories response format',
          ));
        }
        try {
          final categories = data
              .map((e) => e.toString())
              .where((s) => s.isNotEmpty)
              .toList();
          return Right(categories);
        } catch (e) {
          return Left(NetworkFailure(message: 'Failed to parse categories: $e'));
        }
      },
    );
  }

  /// Fetches a single product by ID.
  Future<Either<NetworkFailure, ProductModel?>> getProductById(int id) async {
    final path = ApiConfig.productByIdPath(id);
    final result = await _client.get(path);
    return result.fold(
      Left.new,
      (response) {
        final data = response.data;
        if (data == null) return const Right(null);
        if (data is! Map<String, dynamic>) {
          return Left(const NetworkFailure(
            message: 'Invalid product response format',
          ));
        }
        try {
          return Right(ProductModel.fromJson(data));
        } catch (e) {
          return Left(NetworkFailure(message: 'Failed to parse product: $e'));
        }
      },
    );
  }

  /// Fetches products by category.
  Future<Either<NetworkFailure, List<ProductModel>>> getProductsByCategory(
    String categoryName,
  ) async {
    final path = ApiConfig.productsByCategoryPath(categoryName);
    final result = await _client.get(path);
    return result.fold(
      Left.new,
      (response) {
        final data = response.data;
        if (data is! List) {
          return Left(NetworkFailure(
            message: 'Invalid products response format',
          ));
        }
        try {
          final models = data
              .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(models);
        } catch (e) {
          return Left(NetworkFailure(message: 'Failed to parse products: $e'));
        }
      },
    );
  }
}
