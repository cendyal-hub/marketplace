import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  /// Internal state — list item di cart
  final List<CartItem> _items = [];

  @override
  List<CartItem> getItems() => List.unmodifiable(_items);

  @override
  void addItem(CartItem item) {
    _items.add(item);
  }

  @override
  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
  }

  @override
  void updateQuantity(int id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
  }

  @override
  void clearCart() {
    _items.clear();
  }
}
