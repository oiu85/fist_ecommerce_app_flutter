//* Cart formatting utilities.
//? Shared across cart presentation.

/// Formats a double as USD string (e.g. 299.99 -> "\$299.99").
String formatCartPrice(double value) => '\$${value.toStringAsFixed(2)}';
