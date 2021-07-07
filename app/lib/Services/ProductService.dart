import 'dart:convert';
import 'dart:io';
import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final Api _api;
  final Map<String, dynamic> _cart; // Product -> size -> quantity

  ProductService({Api api})
      : _api = api,
        _cart = ProductService.getCart();

  static Map<String, dynamic> getCart() {
    String rawCart = SharedPreferenceService.instance.getString('cart');
    print(rawCart);
    if (rawCart == null) return new Map<String, dynamic>();
    return jsonDecode(rawCart);
  }

  Future<bool> addToCart(OrderProduct product) async {
    if (_cart.containsKey(product.product.id)) {
      if (_cart[product.product.id].containsKey(product.size))
        _cart[product.product.id][product.size] += 1;
    } else {
      _cart.putIfAbsent(product.product.id, () {
        Map<String, int> ret = {};
        ret.putIfAbsent(product.size, () => 1);
        return ret;
      });
    }

    return await SharedPreferenceService.instance
        .setString('cart', jsonEncode(_cart));
  }

  // Future<bool> removeFromCart(OrderProduct product) async {
  //   _cart.remove(product.toJson().toString());
  //   return await SharedPreferenceService.instance.setStringList('cart', _cart);
  // }

  Future<bool> placeOrder(Order order) async {
    Map<String, dynamic> response =
        await _api.post('order/add', order.toJson());
    bool placed = response != null;
    if (placed) {
      await SharedPreferenceService.instance.remove('cart');
    }
    return placed;
  }

  Future<bool> addCategory(Category category) async {
    Map<String, dynamic> response =
        await _api.post('category/add', category.toJson());
    return response != null;
  }

  Future<bool> addOrder(Order order) async {
    Map<String, dynamic> response =
        await _api.post('order/add', order.toJson());
    return response != null;
  }

  Future<bool> addProduct(Product product) async {
    Map<String, dynamic> response =
        await _api.post('product/add', product.toJson());
    return response != null;
  }

  Future<bool> removeCategory(Category category) async {
    Map<String, dynamic> response =
        await _api.post('category/remove', category.toJson());
    return response != null;
  }

  Future<bool> removeOrder(Order order) async {
    Map<String, dynamic> response =
        await _api.post('order/remove', order.toJson());
    return response != null;
  }

  Future<bool> removeProduct(Product product) async {
    Map<String, dynamic> response =
        await _api.post('product/remove', product.toJson());
    return response != null;
  }

  Future<bool> updateCategory(Category category) async {
    Map<String, dynamic> response =
        await _api.post('category/update', category.toJson());
    return response != null;
  }

  Future<bool> updateOrder(Order order) async {
    Map<String, dynamic> response =
        await _api.post('order/update', order.toJson());
    return response != null;
  }

  Future<bool> updateProduct(Product product) async {
    Map<String, dynamic> response =
        await _api.post('product/update', product.toJson());
    return response != null;
  }
}
