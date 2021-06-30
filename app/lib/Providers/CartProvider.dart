import 'package:app/Models/Product.dart';

class Cart {
  // final List<Product> _products = [];
  final Map<Product, int> _products = Map<Product, int>();

  void addProductToCart(Product p) {
    if (_products.containsKey(p)) {
      _products[p] += 1;
    } else {
      for (Product d in _products.keys) {
        if (p.id == d.id) {
          _products[d] += 1;
          return;
        }
      }
      _products[p] = 1;
    }
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
    for (Product d in _products.keys) {
      if (d.id == p.id) return _products[d];
    }
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
