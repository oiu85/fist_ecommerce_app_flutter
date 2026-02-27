import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';
import '../../domain/entities/create_product_input.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

//* Implementation of [IProductRepository].
//? Maps NetworkFailure → Failure; ProductModel → Product.

class ProductRepositoryImpl implements IProductRepository {
  ProductRepositoryImpl(this._dataSource);

  final ProductRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    final result = await _dataSource.getProducts();
    return result.fold(
      (nf) => Left(Failure(message: nf.message)),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    final result = await _dataSource.getCategories();
    return result.fold(
      (nf) => Left(Failure(message: nf.message)),
      Right.new,
    );
  }

  @override
  Future<Either<Failure, Product?>> getProductById(int id) async {
    final result = await _dataSource.getProductById(id);
    return result.fold(
      (nf) => Left(Failure(message: nf.message)),
      (model) => Right(model?.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryName,
  ) async {
    final result = await _dataSource.getProductsByCategory(categoryName);
    return result.fold(
      (nf) => Left(Failure(message: nf.message)),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Product>> addProduct(
    CreateProductInput input,
  ) async {
    final result = await _dataSource.addProduct(input);
    return result.fold(
      (nf) => Left(Failure(message: nf.message)),
      (model) => Right(model.toEntity()),
    );
  }
}
