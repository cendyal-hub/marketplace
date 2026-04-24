import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';

class ClearCart {
  final CartRepository _repository;

  const ClearCart(this._repository);

  void execute() => _repository.clearCart();
}
