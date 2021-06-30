import 'dart:convert';

import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/Widgets/Product/ProductDialog.dart';
import 'package:app/Providers/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class ProductGridTile extends StatefulWidget {
  final Product product;
  final double width;
  const ProductGridTile({
    @required this.product,
    this.width,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductGridTile> {
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    ThemeData theme = Theme.of(context);
    TextStyle header =
        new TextStyle(color: theme.textTheme.bodyText1.color, fontSize: 18);
    return GridTile(
        footer: Container(
          color: theme.accentColor,
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.name,
                style: header,
              ),
              Text('R${widget.product.price}', style: header)
            ],
          ),
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/product',
                  arguments: {"id": widget.product.id});
              // showDialog(
              //     context: context,
              //     builder: (c) {
              //       return ProductDialog(product: widget.product);
              //     });
            },
            child: SizedBox(
                width: 300,
                // color: Colors.grey[300],
                height: 300,
                child: FittedBox(
                  fit: BoxFit.contain,
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Image.memory(
                        Base64Decoder().convert(widget.product.image),
                      ),
                      cart.getProductCount(widget.product) > 0
                          ? Text(
                              cart.getProductCount(widget.product).toString())
                          : Container()
                    ],
                  ),
                ))));
    // child: GestureDetector(
    //     onTap: () {
    //       showDialog(
    //           context: context,
    //           builder: (c) {
    //             return ProductDialog(product: widget.product);
    //           });
    //     },
    //     child: Container(
    //       padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
    //       color: Colors.white,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [

    //           Divider(),

    //         ],
    //       ),
    //       width: widget.width,
    //     )));
  }
}
