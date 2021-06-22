import 'package:flutter/material.dart';
import 'package:app/Models/Product.dart';

import 'package:app/Widgets/Product/ProductGridTile.dart';

const double productTileWidth = 300;

class ProductGrid extends StatefulWidget {
  List<Product> products = [];

  ProductGrid({@required List<Product> this.products, Key key})
      : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    int hcount = (MediaQuery.of(context).size.width / productTileWidth).round();
    return GridView.count(
      padding: EdgeInsets.all(7),
      crossAxisCount: hcount,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: widget.products.isEmpty
          ? [Text("No products")]
          : widget.products
              .map<Widget>((product) =>
                  ProductGridTile(product: product, width: productTileWidth))
              .toList(),
    );
  }
}
