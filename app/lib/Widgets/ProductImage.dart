import 'dart:convert';
import 'dart:io';

import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
// import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProductImage extends StatefulWidget {
  final Product product;
  final double width;
  final double height;

  const ProductImage({
    @required this.product,
    this.width,
    this.height,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductImage> {
  @override
  Widget build(BuildContext context) {
    return widget.product.image.isEmpty
        ? Text("No Image")
        : Image.memory(
            Base64Decoder().convert(widget.product.image),
            width: widget.width,
            height: widget.height,
            scale: 0.1,
          );
  }
}
