
import 'dart:convert';
import 'dart:io';

import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
// import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProductOrder extends StatefulWidget {
  final OrderProduct order;

  const ProductOrder({
    @required this.order,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductOrder> {
  @override
  Widget build(BuildContext context) {
    int max = widget.order.product.stock.firstWhere((stock) => stock.size == widget.order.size).value;
    if (widget.order.value > max) {
      widget.order.value = max;
    }
    return Column(
      children: [
        Text(widget.order.product.name),
        Row(
          children: [
            Text("Size:"),
            SizedBox(width: 10.0),
            DropdownButton(
              value: widget.order.size,
              items: widget.order.product.stock
                  .map((stock) => DropdownMenuItem(
                child: Text(stock.size),
                value: stock.size,
              )).toList(),
              onChanged: (value) {
                setState(() {
                  widget.order.size = value;
                });
              },
            ),
          ],
        ),
        Row(
          children: [
            Text("Amount:"),
            SizedBox(width: 10.0),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                var a = widget.order.value - 1;
                if (a > 0) {
                  setState(() {
                    widget.order.value = a;
                  });
                }
              },
            ),
            Text(widget.order.value.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                var a = widget.order.value + 1;
                if (a <= max) {
                  setState(() {
                    widget.order.value = a;
                  });
                }
              },
            ),
          ],
        )
      ],
    );
  }
}