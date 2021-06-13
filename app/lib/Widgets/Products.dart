import 'package:flutter/material.dart';
import 'package:app/Models/Product.dart';
import 'dart:convert';

const double productTileWidth = 200;

class ProductTile extends StatelessWidget {
  final Product product;
  ProductTile({@required Product this.product, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Image.memory(
                Base64Decoder().convert(product.image),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(product.name), Text('R${product.price}')],
            ),
          ],
        ),
        width: productTileWidth,
        height: 400);
  }
}

class Products extends StatefulWidget {
  List<Product> products = [];

  Products({@required List<Product> this.products, Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    int hcount = (MediaQuery.of(context).size.width / productTileWidth).round();
    return Container(
      color: Colors.grey,
      child: GridView.count(
        padding: EdgeInsets.all(7),
        crossAxisCount: hcount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: widget.products.isEmpty
            ? [Text("No products")]
            : widget.products
                .map<Widget>((product) => ProductTile(product: product))
                .toList(),
      ),
    );
  }
}
