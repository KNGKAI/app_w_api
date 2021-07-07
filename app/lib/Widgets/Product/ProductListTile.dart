import 'package:flutter/material.dart';
import 'package:skate/Models/Product.dart';
import 'dart:convert';

class ProductListTile extends StatelessWidget {
  final Product product;
  final List<Widget> Function(BuildContext, Product) actionBuilder;
  const ProductListTile(
      {@required Product this.product, this.actionBuilder, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: product.image != null
            ? Image.memory(
                Base64Decoder().convert(product.image),
              )
            : Icon(Icons.broken_image),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(product.name)),
            Container(
              width: 100,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actionBuilder(context, product),
              ),
            ),
            Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.filter_none),
                  Padding(
                    child: Text('${product.stock.length}'),
                    padding: EdgeInsets.all(4),
                  )
                ],
              ),
            ),
            Container(width: 100, child: Text('R${product.price}.00'))
          ],
        ));
  }
}
