import 'dart:convert';

import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Services/Api.dart';

class Cart {
  final List<OrderProduct> _products;

  List<OrderProduct> get products => _products;
  final _api;
  Cart(Api api)
      : _products = Cart.load(),
        _api = api;

  Future<bool> checkout(User u) async {
    int total = 0;
    _products.forEach((element) {
      total += element.product.price * element.value;
    });
    Order order = new Order(
        products: _products,
        reference: "SomeHeckenRefrence",
        status: "Placed",
        user: u,
        total: total);
    Map<String, dynamic> response =
        await _api.post('order/add', order.toJson());
    print(response);
    return response != null;
  }

  void addProductToCart(OrderProduct s) {
    for (OrderProduct i in _products)
      if (i.product.id == s.product.id && i.size == s.size) {
        i.value++;
        save();
        return;
      }
    _products.add(s);
    save();
  }

  void clearCart() {
    _products.clear();
    save();
  }

  List<Product> getProductsInCart() {
    return _products.map((e) => e.product).toList();
  }

  void save() {
    List<String> serial = _products.map((e) => jsonEncode(e.toJson())).toList();
    SharedPreferenceService.instance.setStringList('cart', serial);
  }

  static List<OrderProduct> load() {
    List<String> serial;
    // SharedPreferenceService.instance.remove('cart');
    try {
      serial = SharedPreferenceService.instance.getStringList('cart');
    } catch (e) {
      serial = [];
    }
    if (serial == null) return [];
    try {
      return serial.map((e) => OrderProduct.fromJson(jsonDecode(e))).toList();
    } catch (e) {
      return [];
    }
  }

  void removeFromCart(OrderProduct s) {
    for (OrderProduct i in _products)
      if (i.product.id == s.product.id && i.size == s.size) {
        i.value--;
        if (i.value <= 0) _products.remove(i);
        save();
        return;
      }
  }
}
