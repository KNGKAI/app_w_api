import 'package:app/Models/Product.dart';

class Cart {
  final List<Product> _products = [];

  void addProductToCart(Product p) {
    _products.add(p);
  }

  List<Product> getProductsInCart() {
    return _products;
  }
}
