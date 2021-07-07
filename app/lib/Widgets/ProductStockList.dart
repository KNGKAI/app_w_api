
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

class ProductStockList extends StatefulWidget {
  final Product product;

  const ProductStockList({
    @required this.product,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductStockList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.product.stock.map((stock) {
        TextEditingController sizeController = TextEditingController(text: stock.size);
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: sizeController,
                onChanged: (value) => stock.size = value,
                decoration: InputDecoration(labelText: "Size"),
              )
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() { stock.value--; }),
                ),
                Text(stock.value.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() { stock.value++; }),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.product.stock.remove(stock);
                });
              },
            )
          ],
        );
      }).toList(),
    );
  }
}