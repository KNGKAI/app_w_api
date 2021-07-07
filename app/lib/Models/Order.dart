// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:skate/Models/Product.dart';
import 'package:skate/Models/User.dart';

class Order {
  String _id;
  User user;
<<<<<<< HEAD
  Map<Product, int> products = new Map<Product, int>();
  String status;
  String reference;
  String createdDateTime;
=======
  String status;
  String reference;
  List<OrderProduct> products;
  int total;
>>>>>>> main

  get id => _id;

  Order.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    user = User.fromJson(json['user']);
<<<<<<< HEAD

    List<Product> hold = [];
    hold = json['product']
        ?.map<Product>((json) => Product.fromJson(json))
        ?.toList();
    hold.map((e) {
      if (products.containsKey(e))
        products[e] += 1;
      else
        products.putIfAbsent(e, () => 1);
    });

    print(products);

    createdDateTime = json['createdDateTime'];

=======
    products = json['products']
        ?.map<OrderProduct>((json) => OrderProduct.fromJson(json))
        ?.toList()
        ?? [];
>>>>>>> main
    status = json['status'];
    reference = json['reference'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() => {
<<<<<<< HEAD
        "id": id,
        "user": user.id,
        "product": products.map((e, k) => MapEntry(e.id, k)),
        "status": status,
        "reference": reference,
      };
=======
    "id": id,
    "user": user.id,
    "products": products
        .map((product) => product.toJson())
        .toList(),
    "status": status,
    "reference": reference,
    "total": total,
  };
>>>>>>> main

  Order({
    String id,
    this.user,
    this.products,
    this.status,
    this.reference,
    this.total,
  }) : _id = id;
}

class OrderProduct{
  Product product;
  String size;
  int value;


  OrderProduct.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json['product']);
    size = json['size'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() => {
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
