import 'package:skate/Models/Category.dart';

class Product {
  String _id;
  String name;
  String description;
  Category category;
  String image;
  int price;
  List<ProductStock> stock;

  String get id => _id;

  Product.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    _id = json['id'];
    name = json['name'];
    description = json['description'];
    category = Category.fromJson(json['category']);
    image = json['image'];
    price = json['price'];
    stock = json['stock']
            ?.map<ProductStock>((json) => ProductStock.fromJson(json))
            ?.toList() ??
        [];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category.id,
        "image": image,
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
    if (json == null) return;
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
