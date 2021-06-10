
import 'dart:convert';

import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  final Function onTap;

  const ProductTile({
    @required this.product,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.product.name),
      subtitle: Text(widget.product.category + " - " + widget.product.size),
      trailing: Text("Stock: ${widget.product.inStock.toString()}"),
      onTap: widget.onTap,
    );
  }
}
