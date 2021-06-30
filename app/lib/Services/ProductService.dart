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

  ProductService({Api api}) : _api = api, _cart = [] {
    // _cart = SharedPreferenceService.instance.getStringList('cart');
  }

  Future<bool> addToCart(OrderProduct product) async {
    // _cart.add(product.);
    return await SharedPreferenceService.instance.setStringList('cart', _cart);
  }

  Future<bool> removeFromCart(Product product) async {
    // List<String> cart =
    //     SharedPreferenceService.instance.getStringList('cart') ?? [];
    // cart.remove(product.id);
    return await SharedPreferenceService.instance.setStringList('cart', _cart);
  }

  List<String> getCart() =>
      SharedPreferenceService.instance.getStringList('cart') ?? [];

  Future<bool> placeOrder(User user) async {
    List<String> cart = SharedPreferenceService.instance.getStringList('cart');
    Map<String, dynamic> body = {
      'user': user.id,
      'products': cart,
      'status': 'placed'
    };
    Map<String, dynamic> response = await _api.post('order/add', body);
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
