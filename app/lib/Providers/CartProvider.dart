import 'package:app/Models/Product.dart';

class Cart {
  // final List<Product> _products = [];
  final Map<Product, num> _products = Map<Product, num>();

  void addProductToCart(Product p) {
    if (_products.containsKey(p))
      _products[p] += 1;
    else
      _products[p] = 1;
  }

  void clearCart() {
    _products.clear();
  }

  List<Product> getProductsInCart() {
    return _products.keys.toList();
  }

  Map<Product, num> getAll() {
    return _products;
  }

  void removeFromCart(Product p) {
    if (!_products.containsKey(p)) return;
    _products[p] -= 1;
    if (_products[p] == 0) _products.remove(p);
  }

  num getProductCount(Product p) {
    if (!_products.containsKey(p)) return 0;
    return _products[p];
  }

  num getCost() {
    num ret = 0;
    for (var mp in _products.entries) {
      ret += mp.key.price * mp.value;
    }
    return ret;
  }
}
