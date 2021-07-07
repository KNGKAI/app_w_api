import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ProductListTile.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(BuildContext, Product) actionBuilder;
  const ProductList({
    @required this.products,
    this.actionBuilder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: products
          .map((product) => Padding(
                child: ProductListTile(
                    product: product, actionBuilder: actionBuilder),
                padding: EdgeInsets.all(6),
              ))
          .toList(),
    );
  }
}
