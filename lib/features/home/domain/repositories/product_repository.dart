import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';
import '../entities/product.dart';

//* Abstract product repository contract.
//? Pure Dart — no Flutter/network. Implemented in data layer.

abstract class IProductRepository {
  /// Fetches all products from the API.
  Future<Either<Failure, List<Product>>> getProducts();

  /// Fetches product categories from the API.
  Future<Either<Failure, List<String>>> getCategories();

  /// Fetches products filtered by [categoryName].
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryName,
  );
}
