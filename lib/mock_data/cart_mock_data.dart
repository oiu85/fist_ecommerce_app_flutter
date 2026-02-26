//* Simple mock data for the cart page. Uses prototype3.png for product image.

/// Asset path for cart item product image (watch prototype).
const String kCartItemPrototypeAsset = 'assets/images/png/prototype3.png';

/// Single cart line item for mock/demo. [unitPrice] is per-unit; line total = quantity * unitPrice.
class CartMockItem {
  const CartMockItem({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.variant,
    required this.quantity,
    required this.unitPrice,
  });

  final String id;
  final String imageUrl;
  final String name;
  final String variant;
  final int quantity;
  final double unitPrice;

  double get lineTotal => quantity * unitPrice;
}

/// Default list of cart items for the cart page (simple mock).
List<CartMockItem> get mockCartItems => [
      const CartMockItem(
        id: '1',
        imageUrl: kCartItemPrototypeAsset,
        name: 'Premium Chronograph Watch',
        variant: 'Black Leather',
        quantity: 1,
        unitPrice: 299.99,
      ),
      const CartMockItem(
        id: '2',
        imageUrl: kCartItemPrototypeAsset,
        name: 'Classic Steel Watch',
        variant: 'Silver / Blue Dial',
        quantity: 2,
        unitPrice: 154.99,
      ),
      const CartMockItem(
        id: '3',
        imageUrl: kCartItemPrototypeAsset,
        name: 'Smart Fitness Watch Pro',
        variant: 'Matte Black',
        quantity: 1,
        unitPrice: 199.99,
      ),
    ];

/// Formats a double as USD string (e.g. 299.99 -> "\$299.99").
String formatCartPrice(double value) => '\$${value.toStringAsFixed(2)}';

/// Sum of all line totals for the given items.
double cartSubtotal(List<CartMockItem> items) =>
    items.fold(0.0, (sum, item) => sum + item.lineTotal);
