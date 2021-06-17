import 'package:flutter/material.dart';
import 'package:app/Models/Product.dart';
import 'dart:convert';

class ProductListTile extends StatelessWidget {
  final Product product;
  const ProductListTile({@required Product this.product, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.memory(
          Base64Decoder().convert(product.image),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(product.name)),
            Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.filter_none),
                  Padding(
                    child: Text('${product.inStock}'),
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
