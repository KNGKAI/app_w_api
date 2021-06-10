import 'dart:io';
import 'package:app/Models/Product.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/Api.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final Api _api;

  ProductService({Api api}) : _api = api;

  static String _token;
  static User _user;

  bool get authorized => _user != null;
  User get user => _user;
  String get token => _token;

  Future<bool> updateProduct(Product product) async {
    Map<String, dynamic> response = await _api
        .post('product/update', product.toJson());
    if (response != null) {
      print(response.toString());
      return true;
    }
    return false;
  }

}
