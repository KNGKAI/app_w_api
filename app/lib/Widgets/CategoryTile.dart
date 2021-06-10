
import 'dart:convert';

import 'package:app/Models/Category.dart';
import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  final Category category;
  final Function onEdit;
  final Function onRemove;

  const CategoryTile({
    @required this.category,
    this.onEdit,
    this.onRemove,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.category.name),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: widget.onRemove,
      ),
      onTap: widget.onEdit,
    );
  }
}
