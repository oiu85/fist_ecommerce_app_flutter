import '../features/home/presentation/widgets/home_product_grid.dart';
import '../features/product_details/presentation/pages/product_details_page.dart';

//* ==================== Product Details Mock Data ====================

/// Asset path for the product details hero image (black wireless headphones).
const String kProductDetailsHeroAsset = 'assets/images/png/prototype2.png';

/// Default payload for product details page (UI/demo).
/// Uses [kProductDetailsHeroAsset] for the hero image.
const ProductDetailsPayload mockProductDetailsPayload = ProductDetailsPayload(
  categoryName: 'Electronics',
  title: 'Premium Wireless Headphones',
  priceFormatted: r'$299.99',
  rating: 4.2,
  reviewCount: 120,
  description:
      'Experience unparalleled audio clarity with our premium wireless headphones. '
      'Featuring advanced noise cancellation technology, 40-hour battery life, and '
      'luxurious memory foam cushions. Crafted with precision for the discerning '
      'audiophile who demands both performance and style.',
  imageUrl: kProductDetailsHeroAsset,
  heroTag: 'product_hero_0',
);

/// Builds [ProductDetailsPayload] from a home grid item (category & description from mock).
ProductDetailsPayload payloadFromHomeItem(HomeProductGridItem item) =>
    ProductDetailsPayload(
      categoryName: mockProductDetailsPayload.categoryName,
      title: item.name,
      priceFormatted: item.priceFormatted,
      rating: item.rating,
      reviewCount: item.reviewCount,
      description: mockProductDetailsPayload.description,
      imageUrl: item.imageUrl,
      heroTag: item.heroTag,
    );
