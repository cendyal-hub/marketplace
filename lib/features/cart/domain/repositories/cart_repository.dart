import 'package:marketplace/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  /// Ambil semua item di cart
  List<CartItem> getItems();

  /// Tambah item ke cart (jika sudah ada, increment quantity)
  void addItem(CartItem item);

  /// Hapus item berdasarkan id
  void removeItem(int id);

  /// Update quantity item berdasarkan id
  /// Jika quantity <= 0, item dihapus
  void updateQuantity(int id, int quantity);

  /// Kosongkan seluruh cart
  void clearCart();
}
