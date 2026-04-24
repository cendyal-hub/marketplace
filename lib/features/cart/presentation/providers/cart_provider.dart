import 'package:flutter/foundation.dart';
import 'package:marketplace/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';
import 'package:marketplace/features/cart/domain/usecases/add_to_cart.dart';
import 'package:marketplace/features/cart/domain/usecases/clear_cart.dart';
import 'package:marketplace/features/cart/domain/usecases/get_cart_items.dart';
import 'package:marketplace/features/cart/domain/usecases/get_cart_total.dart';
import 'package:marketplace/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:marketplace/features/cart/domain/usecases/update_quantity.dart';

class CartProvider extends ChangeNotifier {
  // ─── Dependencies (injected) ─────────────────────────────
  late final CartRepository _repository;
  late final AddToCart _addToCart;
  late final RemoveFromCart _removeFromCart;
  late final UpdateQuantity _updateQuantity;
  late final GetCartItems _getCartItems;
  late final GetCartTotal _getCartTotal;
  late final ClearCart _clearCart;

  CartProvider() {
    // Dependency injection manual — bisa ganti dengan get_it jika diperlukan
    _repository = CartRepositoryImpl();
    _addToCart = AddToCart(_repository);
    _removeFromCart = RemoveFromCart(_repository);
    _updateQuantity = UpdateQuantity(_repository);
    _getCartItems = GetCartItems(_repository);
    _getCartTotal = GetCartTotal(_repository);
    _clearCart = ClearCart(_repository);
  }

  // ─── Getters (computed dari domain) ─────────────────────
  /// List item di cart — UI hanya membaca, tidak memodifikasi langsung
  List<CartItem> get items => _getCartItems.execute();

  /// Total harga — dihitung di domain layer, bukan di UI
  double get total => _getCartTotal.execute();

  /// Jumlah total item (untuk badge icon cart)
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Apakah cart kosong
  bool get isEmpty => items.isEmpty;

  // ─── Actions (delegate ke use case) ─────────────────────

  /// Tambah item ke cart dari product detail
  void addItem(CartItem item) {
    _addToCart.execute(item);
    notifyListeners();
  }

  /// Hapus item dari cart
  void removeItem(int id) {
    _removeFromCart.execute(id);
    notifyListeners();
  }

  /// Update quantity (termasuk increment/decrement)
  void updateQuantity(int id, int quantity) {
    _updateQuantity.execute(id, quantity);
    notifyListeners();
  }

  /// Kosongkan cart setelah checkout berhasil
  void clearCart() {
    _clearCart.execute();
    notifyListeners();
  }
}
