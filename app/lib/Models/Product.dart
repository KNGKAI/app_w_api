// import 'package:google_maps_flutter/google_maps_flutter.dart';
import './Category.dart';

class Size {
  String size;
  int stock;

  Size.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    stock = json['value'];
  }
  Size(this.size, this.stock);
}

class Product {
  String _id;
  String name;
  String description;
  String category;
  String image;
  int price;
  List<ProductStock> stock;

  String get id => _id;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    price = json['price'];
    stock = json['stock']
            ?.map<ProductStock>((json) => ProductStock.fromJson(json))
            ?.toList() ??
        [];
  }

  Map<String, dynamic> toJson({img = true}) => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "image": (img ? image : null),
        "price": price,
        "stock": stock.map((e) => e.toJson()).toList(),
      };

  Product({
    String id,
    this.name,
    this.description,
    this.category,
    this.image,
    this.price,
    this.stock,
  }) : _id = id;
}

class ProductStock {
  String size;
  int value;

  ProductStock.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() => {
        "size": size,
        "value": value,
      };

  ProductStock({
    this.size,
    this.value,
  });
}
