//* Shared domain failure type for framework-agnostic repository contracts.
//? Used by features to represent business/network failures without coupling to Dio/Flutter.

/// Domain-level failure representation.
/// Data layer maps [NetworkFailure] to this when returning from repositories.
class Failure {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => message;
}
