import 'package:skate/Models/Product.dart';
import 'package:skate/Models/User.dart';

class Order {
  String _id;
  User user;
  String address;
  String status;
  String reference;
  List<OrderProduct> products;
  int fee;
  int total;

  get id => _id;

  Order.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    _id = json['id'];
    user = User.fromJson(json['user']);
    address = json['address'];
    products = json['products']
            ?.map<OrderProduct>((json) => OrderProduct.fromJson(json))
            ?.toList() ??
        [];
    status = json['status'];
    reference = json['reference'];
    total = json['total'];
    fee = json['fee'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.id,
        "address": address,
        "products": products.map((product) => product.toJson()).toList(),
        "status": status,
        "reference": reference,
        "total": total,
        "fee": fee,
      };

  Order({
    String id,
    this.user,
    this.address,
    this.products,
    this.status,
    this.reference,
    this.total,
    this.fee,
  }) : _id = id;
}

class OrderProduct {
  Product product;
  String size;
  int value;

  OrderProduct.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
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
