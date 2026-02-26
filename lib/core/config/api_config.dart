
class ApiConfig {
  /// Base URL for all API requests.
  static const String baseUrl = 'https://fakestoreapi.com';

  //* ─── Home / Products API ───────────────────────────────────────────────

  /// All products list.
  static const String productsPath = '/products';

  /// Product categories list.
  static const String productsCategoriesPath = '/products/categories';

  /// Products filtered by category. Use API category name as-is.
  static String productsByCategoryPath(String categoryName) =>
      '/products/category/$categoryName';

  /// TODO: Add more endpoints as needed
  // static const String register = '$baseUrl/auth/register';
  // static const String refreshToken = '$baseUrl/auth/refresh';
}
