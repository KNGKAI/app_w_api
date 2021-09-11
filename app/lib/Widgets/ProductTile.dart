import 'dart:convert';

import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skate/Widgets/ProductImage.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  final Function onTap;
  final Function onRemove;

  const ProductTile({
    @required this.product,
    this.onTap,
    this.onRemove,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProductImage(product: widget.product),
      title: Text(widget.product.name),
      subtitle: Text(widget.product.category.name),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: widget.onRemove,
      ),
      onTap: widget.onTap,
    );
  }
}
