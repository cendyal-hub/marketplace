import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository _repository;

  const AddToCart(this._repository);

  void execute(CartItem item) {
    final existing = _repository
        .getItems()
        .where((i) => i.id == item.id)
        .firstOrNull;

    if (existing != null) {
      // Sudah ada → increment quantity
      _repository.updateQuantity(item.id, existing.quantity + item.quantity);
    } else {
      // Belum ada → tambah baru
      _repository.addItem(item);
    }
  }
}
