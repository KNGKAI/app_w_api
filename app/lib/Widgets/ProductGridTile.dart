import 'dart:convert';

import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductGridTile extends StatefulWidget {
  final Product product;
  final double width;
  const ProductGridTile({
    @required this.product,
    this.width,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductGridTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/product', arguments: widget.product);
        },
        child: Container(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Image.memory(
                    Base64Decoder().convert(widget.product.image),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.product.name),
                    Text('R${widget.product.price}')
                  ],
                ),
              ],
            ),
            width: widget.width,
            height: 400));
  }
}
