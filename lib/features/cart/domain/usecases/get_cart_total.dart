import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';

class GetCartTotal {
  final CartRepository _repository;

  const GetCartTotal(this._repository);

  /// Mengembalikan total harga semua item (price × quantity)
  double execute() {
    final items = _repository.getItems();
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Hitung total dari list yang sudah ada (tanpa re-query repository)
  double executeFromList(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }
}
