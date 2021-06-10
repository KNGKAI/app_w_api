
import 'dart:convert';

import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Product _cachedInitialProduct;

  @override
  void initState() {
    _cachedInitialProduct = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: widget.product.name);
    TextEditingController descriptionController = TextEditingController(text: widget.product.description);
    TextEditingController sizeController = TextEditingController(text: widget.product.size);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 10),
        TextField(
          controller: sizeController,
          onChanged: (value) => widget.product.size = value,
          decoration: InputDecoration(
            labelText: "Size:",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
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
        Text("In Stock:"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  widget.product.inStock--;
                  if (widget.product.inStock < 0) {
                    widget.product.inStock = 0;
                  }
                });
              },
            ),
            Text(widget.product.inStock.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.product.inStock++;
                });
              },
            )
          ],
        ),
        Image.memory(Base64Decoder().convert(widget.product.image), width: MediaQuery.of(context).size.width / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text("Upload", style: TextStyle(color: Colors.white)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () {
                print('upload');
              },
            ),
            TextButton(
              child: Text("Take Photo", style: TextStyle(color: Colors.white)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () {
                print('take photo');
              },
            ),
          ],
        ),
      ],
    );
  }
}
