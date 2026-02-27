import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../datasources/cart_remote_data_source.dart';

//* Implements [ICartRepository]. SQLite is source of truth.
//? Optionally calls remote for simulation (fire-and-forget).

class CartRepositoryImpl implements ICartRepository {
  CartRepositoryImpl(this._local, this._remote);

  final CartLocalDataSource _local;
  final CartRemoteDataSource _remote;

  static const int _kDefaultUserId = 1;

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final models = await _local.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addOrUpdateItem(int productId, int quantity) async {
    await _local.addOrUpdate(productId, quantity);
    _syncToRemote(productId, quantity, isAdd: true);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    await _local.updateQuantity(productId, quantity);
    _syncToRemote(productId, quantity, isAdd: false);
  }

  @override
  Future<void> removeItem(int productId) async {
    await _local.remove(productId);
    _syncDeleteToRemote();
  }

  @override
  Future<int> getItemCount() async => _local.getItemCount();

  /// Fire-and-forget sync to FakeStoreAPI (simulation only).
  void _syncToRemote(int productId, int quantity, {required bool isAdd}) {
    _local.getAll().then((items) {
      final products = items
          .map((m) => CartProductItem(productId: m.productId, quantity: m.quantity))
          .toList();
      if (isAdd && !products.any((p) => p.productId == productId)) {
        products.add(CartProductItem(productId: productId, quantity: quantity));
      }
      _remote.createCart(_kDefaultUserId, products).then((_) {});
    });
  }

  void _syncDeleteToRemote() {
    _local.getAll().then((items) {
      final products = items
          .map((m) => CartProductItem(productId: m.productId, quantity: m.quantity))
          .toList();
      _remote.createCart(_kDefaultUserId, products).then((_) {});
    });
  }
}
