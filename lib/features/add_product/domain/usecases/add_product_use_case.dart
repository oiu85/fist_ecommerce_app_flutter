import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';
import '../../../home/domain/entities/create_product_input.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/domain/repositories/product_repository.dart';

//* Use case to create a new product via POST /products.
//? BLoC uses this; never accesses repository directly.

class AddProductUseCase {
  AddProductUseCase(this._repository);

  final IProductRepository _repository;

  Future<Either<Failure, Product>> call(CreateProductInput input) =>
      _repository.addProduct(input);
}
