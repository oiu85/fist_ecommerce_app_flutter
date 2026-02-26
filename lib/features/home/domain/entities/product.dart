//* Domain entity for a product.
//? Pure Dart — no Flutter/network imports. Used by use cases and BLoC state.

/// Rating value object for a product.
class ProductRating {
  const ProductRating({
    required this.rate,
    required this.count,
  });

  final double rate;
  final int count;
}

/// Product domain entity.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final ProductRating rating;
}
