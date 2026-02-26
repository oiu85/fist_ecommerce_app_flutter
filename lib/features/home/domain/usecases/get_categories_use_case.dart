import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';
import '../repositories/product_repository.dart';

//* Use case to fetch product categories.
//? BLoC uses this; never accesses repository directly.

class GetCategoriesUseCase {
  GetCategoriesUseCase(this._repository);

  final IProductRepository _repository;

  Future<Either<Failure, List<String>>> call() => _repository.getCategories();
}
