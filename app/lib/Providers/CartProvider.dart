import 'package:app/Models/Product.dart';

class Cart {
  final List<Product> _products = [];

  void addProductToCart(Product p) {
    _products.add(p);
  }

  List<Product> getProductsInCart() {
    return _products;
  }

  void removeFromCart(Product p) {
    _products.remove(p);
  }

  num getCost() {
    num ret = 0;
    for (var p in _products) {
      ret += p.price;
    }
    return ret;
  }
}
