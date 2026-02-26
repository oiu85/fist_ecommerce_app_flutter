import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

//* Use case to fetch products (all or by category).
//? BLoC uses this; never accesses repository directly.

class GetProductsUseCase {
  GetProductsUseCase(this._repository);

  final IProductRepository _repository;

  /// Fetches products. If [category] is null or 'all', fetches all products.
  /// Otherwise fetches products for the given category.
  Future<Either<Failure, List<Product>>> call({String? category}) {
    if (category == null || category == 'all' || category.isEmpty) {
      return _repository.getProducts();
    }
    return _repository.getProductsByCategory(category);
  }
}
