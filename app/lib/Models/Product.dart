// import 'package:google_maps_flutter/google_maps_flutter.dart';

class Product {
  String _id;
  String name;
  String description;
  String category;
  String size;
  String image;
  int price;
  int inStock;

  String get id => _id;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    size = json['size'];
    image = json['image'];
    price = json['price'];
    inStock = json['inStock'];
  }

  Product.create() {
    name = "";
    description = "";
    size = "";
    price = 0;
    inStock = 0;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "size": size,
        // "image": image,
        "price": price,
        "inStock": inStock,
      };

  bool operator ==(Object eq) {
    Product p = eq as Product;
    return p.id == id;
  }

  Product({
    String id,
    this.name,
    this.description,
    this.category,
    this.size,
    this.image,
    this.price,
    this.inStock,
  }) : _id = id;
}
