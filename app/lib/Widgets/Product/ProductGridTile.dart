import 'dart:convert';

import 'package:skate/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    ThemeData theme = Theme.of(context);

    String sizes = widget.product.stock
        .map((e) => e.value > 0 ? e.size : 0)
        .toList()
        .join(', ');
    return GridTile(
        footer: Container(
            color: theme.accentColor,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name,
                      style: theme.accentTextTheme.headline6,
                    ),
                    Text('R${widget.product.price}',
                        style: theme.accentTextTheme.headline6)
                  ],
                ),
                Text('(${sizes})', style: theme.accentTextTheme.subtitle1)
              ],
            )),
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
                width: 200,
                // color: Colors.grey[300],
                // height: 300,
                child: FittedBox(
                  fit: BoxFit.contain,
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Image.memory(
                        Base64Decoder().convert(widget.product.image),
                      ),
                      // cart.getProductCount(widget.product) > 0
                      //     ? Text(
                      //         cart.getProductCount(widget.product).toString())
                      //     : Container()
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
