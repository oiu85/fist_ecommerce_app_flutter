import 'package:intl/intl.dart';

import '../../domain/entities/product.dart';
import '../widgets/home_product_grid.dart';
import '../../../product_details/presentation/pages/product_details_page.dart';

//* Mappers from domain Product to UI types.
//? Keeps presentation layer dumb; mapping logic centralized here.

/// Formats price for display (e.g. \$109.95).
String _formatPrice(double price) => NumberFormat.currency(symbol: r'$', decimalDigits: 2).format(price);

HomeProductGridItem productToGridItem(Product product) => HomeProductGridItem(
  name: product.title,
  rating: product.rating.rate,
  reviewCount: product.rating.count,
  priceFormatted: _formatPrice(product.price),
  imageUrl: product.imageUrl,
  heroTag: 'product_hero_${product.id}',
);

/// Maps domain [Product] to [ProductDetailsPayload] for navigation.
ProductDetailsPayload payloadFromProduct(Product product) => ProductDetailsPayload(
  categoryName: product.category,
  title: product.title,
  priceFormatted: _formatPrice(product.price),
  rating: product.rating.rate,
  reviewCount: product.rating.count,
  description: product.description,
  imageUrl: product.imageUrl,
  heroTag: 'product_hero_${product.id}',
);
