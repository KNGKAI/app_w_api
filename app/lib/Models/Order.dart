// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:skate/Models/Product.dart';
import 'package:skate/Models/User.dart';

class Order {
  String _id;
  User user;
  String status;
  String reference;
  List<OrderProduct> products;
  int total;

  get id => _id;

  Order.fromJson(Map<String, dynamic> json) {
    print(json);
    _id = json['id'];
    user = User.fromJson(json['user']);
    products = json['products']
            ?.map<OrderProduct>((json) => OrderProduct.fromJson(json))
            ?.toList() ??
        [];
    status = json['status'];
    reference = json['reference'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.id,
        "products": products.map((product) => product.toOrderJson()).toList(),
        "status": status,
        "reference": reference,
        "total": total,
      };

  Order({
    String id,
    this.user,
    this.products,
    this.status,
    this.reference,
    this.total,
  }) : _id = id;
}

class OrderProduct {
  Product product;
  String size;
  int value;

  OrderProduct.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json['product']);
    size = json['size'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "size": size,
        "value": value,
      };
  Map<String, dynamic> toOrderJson() => {
        "product": product.id,
        "size": size,
        "value": value,
      };

  OrderProduct({
    this.product,
    this.size,
    this.value,
  });
}
