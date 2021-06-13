import 'dart:convert';

import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductGridTile extends StatefulWidget {
  final Product product;
  final Function onTap;


  const ProductGridTile({
    @required this.product,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductGridTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Image.memory(Base64Decoder().convert(widget.product.image), scale: 0.01),
          widget.product.inStock > 0
              ? Container()
              : Text("Out of Stock",
                  style: TextStyle(color: Colors.red, fontSize: 30))
        ],
      ),
    );
  }
}
