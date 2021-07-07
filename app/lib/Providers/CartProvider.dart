import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';

class Cart {
  // final List<Product> _products = [];
  final List<OrderProduct> _products = [];

  List<OrderProduct> get products => _products;

  void addProductToCart(OrderProduct s) {
    for (OrderProduct i in _products)
      if (i.product.id == s.product.id && i.size == s.size) {
        i.value++;
        return;
      }
    _products.add(s);
  }

  void clearCart() {
    _products.clear();
  }

  List<Product> getProductsInCart() {
    return _products.map((e) => e.product).toList();
  }

  void removeFromCart(OrderProduct s) {
    for (OrderProduct i in _products)
      if (i.product.id == s.product.id && i.size == s.size) {
        i.value--;
        if (i.value <= 0) _products.remove(i);
        return;
      }
  }
}
