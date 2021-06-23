// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:app/Models/Product.dart';
import 'package:app/Models/User.dart';

class Order {
  String _id;
  User user;
  Map<Product, int> products = new Map<Product, int>();
  String status;
  String reference;

  get id => _id;

  Order.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    user = User.fromJson(json['user']);

    List<Product> hold = [];
    hold = json['product']
        ?.map<Product>((json) => Product.fromJson(json))
        ?.toList();
    hold.map((e) {
      if (products.containsKey(e))
        products[e] += 1;
      else
        products[e] = 1;
    });

    status = json['status'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.id,
        "product": products.map((e, k) => MapEntry(e.id, k)),
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
