import 'package:app/Models/Product.dart';
import 'package:app/Views/ProductView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;

  const ProductList({
    @required this.products,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.products
          .map((product) => ListTile(title: Text(product.name)))
          .toList(),
    );
  }
}
