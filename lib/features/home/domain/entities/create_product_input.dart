//* Domain input DTO for creating a new product.
//? Pure Dart — no JSON/Flutter. Used by IProductRepository.addProduct and AddProductUseCase.

/// Input parameters for POST /products.
class CreateProductInput {
  const CreateProductInput({
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
}
