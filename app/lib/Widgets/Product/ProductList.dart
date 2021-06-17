import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ProductListTile.dart';

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
    return ListView(
      children: widget.products
          .map((product) => Padding(
                child: ProductListTile(product: product),
                padding: EdgeInsets.all(6),
              ))
          .toList(),
    );
  }
}
