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

  Future<APIResponse> placeOrder(Order order) async {
    APIResponse response = await _api.post('order/add', order.toJson());
    bool placed = response.success;
    if (placed) {
      await SharedPreferenceService.instance.remove('cart');
    }
    return response;
  }

  Future<APIResponse> addCategory(Category category) =>
      _api.post('category/add', category.toJson());

  Future<APIResponse> addOrder(Order order) =>
      _api.post('order/add', order.toJson());

  Future<APIResponse> addProduct(Product product) =>
      _api.post('product/add', product.toJson());

  Future<APIResponse> removeCategory(Category category) =>
      _api.post('category/remove', category.toJson());

  Future<APIResponse> removeOrder(Order order) =>
      _api.post('order/remove', order.toJson());

  Future<APIResponse> removeProduct(Product product) =>
      _api.post('product/remove', product.toJson());

  Future<APIResponse> updateCategory(Category category) =>
      _api.post('category/update', category.toJson());

  Future<APIResponse> updateOrder(Order order) =>
      _api.post('order/update', order.toJson());

  Future<APIResponse> updateProduct(Product product) =>
      _api.post('product/update', product.toJson());
}
