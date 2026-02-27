import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';
import 'product_model.dart';

part 'create_product_response_model.freezed.dart';
part 'create_product_response_model.g.dart';

//* Data model for POST /products 201 response.
//? FakeStoreAPI may omit rating; default to ProductRating(0, 0).

@freezed
abstract class CreateProductResponseModel with _$CreateProductResponseModel {
  const CreateProductResponseModel._();

  const factory CreateProductResponseModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    @JsonKey(name: 'image') required String image,
    @JsonKey(name: 'rating') ProductRatingModel? rating,
  }) = _CreateProductResponseModel;

  factory CreateProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateProductResponseModelFromJson(json);

  /// Maps to domain [Product]; uses default rating when API omits it.
  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        imageUrl: image,
        rating: rating?.toEntity() ?? const ProductRating(rate: 0, count: 0),
      );
}
