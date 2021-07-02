// import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  String size;
  String image;
  int price;
  List<Size> stock = [];

  String get id => _id;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    size = json['size'];
    image = json['image'];
    price = json['price'];

    if (json.containsKey('stock'))
      for (Map<String, dynamic> i in json['stock'] as List<dynamic>)
        stock.add(Size.fromJson(i));
    print(stock);
  }

  Product.create() {
    name = "";
    description = "";
    size = "";
    price = 0;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "size": size,
        // "image": image,
        "price": price,
        // "inStock": inStock,
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
    // this.inStock,
  }) : _id = id;
}
