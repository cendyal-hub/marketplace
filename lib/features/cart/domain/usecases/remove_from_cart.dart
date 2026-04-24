import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository _repository;

  const RemoveFromCart(this._repository);

  void execute(int id) {
    _repository.removeItem(id);
  }
}
