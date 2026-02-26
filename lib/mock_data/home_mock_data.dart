import '../core/localization/locale_keys.g.dart';
import '../features/home/presentation/widgets/home_category_chips.dart';
import '../features/home/presentation/widgets/home_product_grid.dart';

//* ==================== Category Mock Data ====================

/// Mock category list for home screen (All, Electronics, Jewelery, etc.).
List<HomeCategoryItem> get mockHomeCategories => const <HomeCategoryItem>[
  HomeCategoryItem(id: 'all', labelLocaleKey: LocaleKeys.home_categoryAll),
  HomeCategoryItem(
    id: 'electronics',
    labelLocaleKey: LocaleKeys.home_categoryElectronics,
  ),
  HomeCategoryItem(
    id: 'jewelery',
    labelLocaleKey: LocaleKeys.home_categoryJewelery,
  ),
  HomeCategoryItem(
    id: 'mens_clothing',
    labelLocaleKey: LocaleKeys.home_categoryMensClothing,
  ),
  HomeCategoryItem(
    id: 'womens_clothing',
    labelLocaleKey: LocaleKeys.home_categoryWomensClothing,
  ),
];

//* ==================== Product Mock Data ====================

/// Default list of placeholder products for the home grid.
List<HomeProductGridItem> get defaultHomeProductGridItems =>
    <HomeProductGridItem>[
      const HomeProductGridItem(
        name: 'Wireless Bluetooth ',
        rating: 4,
        reviewCount: 124,
        priceFormatted: r'$89.99',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
      const HomeProductGridItem(
        name: 'Gold Plated Chain Necklace',
        rating: 4,
        reviewCount: 89,
        priceFormatted: r'$45.50',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
      const HomeProductGridItem(
        name: 'Classic Denim Jacket for Men',
        rating: 4,
        reviewCount: 203,
        priceFormatted: r'$79.00',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
      const HomeProductGridItem(
        name: 'Floral Summer Dress',
        rating: 4,
        reviewCount: 156,
        priceFormatted: r'$54.99',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
      const HomeProductGridItem(
        name: 'Smart Fitness Watch Pro',
        rating: 4,
        reviewCount: 342,
        priceFormatted: r'$199.99',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
      const HomeProductGridItem(
        name: 'Sterling Silver Bracelet',
        rating: 4,
        reviewCount: 67,
        priceFormatted: r'$129.00',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
      const HomeProductGridItem(
        name: "Men's Casual Sneakers",
        rating: 4,
        reviewCount: 278,
        priceFormatted: r'$69.99',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
      const HomeProductGridItem(
        name: 'Leather Crossbody Bag',
        rating: 4,
        reviewCount: 192,
        priceFormatted: r'$149.00',
        imageUrl: kHomeProductPlaceholderAsset,
      ),
    ];
