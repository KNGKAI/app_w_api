// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app/Models/Product.dart';
import 'package:app/Models/User.dart';

class Order {
  String _id;
  User user;
  List<Product> products;
  String status;
  String reference;

  get id => _id;

  Order.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    user = User.fromJson(json['user']);
    products = json['product']?.map<Product>((json) => Product.fromJson(json))?.toList() ?? [];
    status = json['status'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.id,
    "product": products.map((e) => e.id).toList(),
    "status": status,
    "reference": reference,
  };

  Order({
    String id,
    this.user,
    this.products,
    this.status,
    this.reference,
  }) : _id = id;
}
