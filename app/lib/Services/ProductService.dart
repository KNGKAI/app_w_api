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
  final List<String> _cart;

  ProductService({Api api}) : _api = api, _cart = ProductService.getCart();

  static List<String> getCart() => SharedPreferenceService.instance.getStringList('cart') ?? [];

  Future<bool> addToCart(OrderProduct product) async {
    _cart.add(json.encode(product.toJson()));
    return await SharedPreferenceService.instance.setStringList('cart', _cart);
  }

  Future<bool> removeFromCart(OrderProduct product) async {
    _cart.remove(product.toJson().toString());
    return await SharedPreferenceService.instance.setStringList('cart', _cart);
  }

  Future<APIResponse> placeOrder(Order order) async {
    APIResponse response = await _api.post('order/add', order.toJson());
    bool placed = response.success;
    if (placed) {
      await SharedPreferenceService.instance.remove('cart');
    }
    return response;
  }

  Future<APIResponse> addCategory(Category category) => _api.post('category/add', category.toJson());

  Future<APIResponse> addOrder(Order order) => _api.post('order/add', order.toJson());

  Future<APIResponse> addProduct(Product product) => _api.post('product/add', product.toJson());

  Future<APIResponse> removeCategory(Category category) => _api.post('category/remove', category.toJson());

  Future<APIResponse> removeOrder(Order order) => _api.post('order/remove', order.toJson());

  Future<APIResponse> removeProduct(Product product) => _api.post('product/remove', product.toJson());

  Future<APIResponse> updateCategory(Category category) => _api.post('category/update', category.toJson());

  Future<APIResponse> updateOrder(Order order) => _api.post('order/update', order.toJson());

  Future<APIResponse> updateProduct(Product product) => _api.post('product/update', product.toJson());
}
