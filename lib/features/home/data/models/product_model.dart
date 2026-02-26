import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

//* Freezed data model for API product response.
//? Used only in data layer; maps to domain Product via toEntity().

@freezed
abstract class ProductRatingModel with _$ProductRatingModel {
  const ProductRatingModel._();

  const factory ProductRatingModel({
    required double rate,
    required int count,
  }) = _ProductRatingModel;

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingModelFromJson(json);

  ProductRating toEntity() => ProductRating(rate: rate, count: count);
}

@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    @JsonKey(name: 'image') required String image,
    required ProductRatingModel rating,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        imageUrl: image,
        rating: rating.toEntity(),
      );
}
