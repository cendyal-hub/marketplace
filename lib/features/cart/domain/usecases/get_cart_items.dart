import 'package:marketplace/features/cart/domain/entities/cart_item.dart';
import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository _repository;

  const GetCartItems(this._repository);

  List<CartItem> execute() => _repository.getItems();
}
