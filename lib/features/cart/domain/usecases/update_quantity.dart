import 'package:marketplace/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantity {
  final CartRepository _repository;

  const UpdateQuantity(this._repository);

  void execute(int id, int quantity) {
    if (quantity <= 0) {
      _repository.removeItem(id);
    } else {
      _repository.updateQuantity(id, quantity);
    }
  }
}
