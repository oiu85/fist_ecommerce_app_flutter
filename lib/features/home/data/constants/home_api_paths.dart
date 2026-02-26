//* API path constants for home product endpoints.
//? Base URL is in ApiConfig; NetworkClient uses it. Paths are relative.

const String productsPath = '/products';
const String productsCategoriesPath = '/products/categories';

/// Path for products filtered by category. Use API category name as-is.
String productsByCategoryPath(String categoryName) =>
    '/products/category/$categoryName';
