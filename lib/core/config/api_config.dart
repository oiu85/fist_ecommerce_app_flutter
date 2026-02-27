import 'package:flutter_dotenv/flutter_dotenv.dart';

//* Central API configuration — reads from .env at runtime
class ApiConfig {
  /// Base URL for all API requests.
  static String get baseUrl =>
      dotenv.get('API_BASE_URL', fallback: 'https://fakestoreapi.com');

  /// Connection timeout in seconds.
  static int get connectTimeoutSeconds =>
      dotenv.getInt('API_TIMEOUT_SECONDS', fallback: 15);

  /// All products list.
  static const String productsPath = '/products';

  /// Product categories list.
  static const String productsCategoriesPath = '/products/categories';

  /// Products filtered by category. Use API category name as-is.
  static String productsByCategoryPath(String categoryName) =>
      '/products/category/$categoryName';

  /// Single product by ID.
  static String productByIdPath(int id) => '/products/$id';

  /// Cart endpoints (FakeStoreAPI; persistence is simulated — use SQLite as source of truth).
  static const String cartsPath = '/carts';
  static String cartByIdPath(int id) => '/carts/$id';

  /// Auth login endpoint.
  static const String authLoginPath = '/auth/login';
  // static const String register = '$baseUrl/auth/register';
  // static const String refreshToken = '$baseUrl/auth/refresh';
}
