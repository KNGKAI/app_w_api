
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
import 'package:skate/Widgets/ProductImage.dart';
import 'package:skate/Widgets/ProductStockList.dart';

class ProductEditing extends StatefulWidget {
  final Product product;
  final List<String> categories;

  const ProductEditing({
    @required this.product,
    this.categories,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductEditing> {

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: widget.product.name);
    TextEditingController descriptionController = TextEditingController(text: widget.product.description);
    TextEditingController priceController = TextEditingController(text: widget.product.price.toString());
    return ListView(
      children: [
        TextField(
          controller: nameController,
          onChanged: (value) => widget.product.name = value,
          decoration: InputDecoration(
            labelText: "Name:",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: descriptionController,
          onChanged: (value) => widget.product.description = value,
          decoration: InputDecoration(
            labelText: "Description:",
            border: OutlineInputBorder(),
          ),
        ),
        Divider(),
        TextField(
          controller: priceController,
          onChanged: (value) => widget.product.price = int.parse(value),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Price",
            border: OutlineInputBorder(),
          ),
        ),
        Divider(),
        Row(
          children: [
            Text("Category:"),
            SizedBox(width: 10.0),
            DropdownButton(
              value: widget.product.category,
              items: widget.categories
                  .map((category) => DropdownMenuItem(
                child: Text(category),
                value: category,
              )).toList(),
              onChanged: (value) {
                setState(() {
                  widget.product.category = value;
                });
              },
            ),
          ],
        ),
        Divider(),
        Text("Stock:"),
        ProductStockList(product: widget.product),
        TextButton(
          child: Text("Add Stock"),
          onPressed: () {
            setState(() {
              widget.product.stock.add(ProductStock(size: "enter_size", value: 1));
            });
          },
        ),
        Divider(),
        ProductImage(product: widget.product),
        Center(
          child: TextButton(
            child: Text("Upload", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
            onPressed: () async {
              var picker = ImagePicker();
              var pickedImage = await picker.getImage(source: ImageSource.gallery);
              var bytes = await pickedImage.readAsBytes();
              var base64 = base64Encode(bytes);
              print(base64);
              setState(() {
                widget.product.image = base64;
              });
            },
          ),
        ),
      ],
    );
  }
}