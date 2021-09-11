import 'dart:convert';

import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skate/Widgets/ProductImage.dart';

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
          ProductImage(product: widget.product),
          // widget.product.inStock < 0
          // Container(
          //         height: 50.0,
          //         width: double.infinity,
          //         color: Colors.red,
          //         child: Center(
          //           child: Text("Out of Stock",
          //               style: TextStyle(color: Colors.white, fontSize: 30)),
          //         ),
          //       )
        ],
      ),
    );
  }
}
