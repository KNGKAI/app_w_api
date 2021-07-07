import 'package:flutter/material.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Providers/CartProvider.dart';
import 'package:provider/provider.dart';
import '../Buttons.dart';
import 'dart:convert';

class ProductDialog extends StatelessWidget {
  final Product product;
  const ProductDialog({@required Product this.product, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    return SimpleDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(product.name),
          Row(
            children: [
              Buttons.addToCartButton(product),
              IconButton(
                  // Close
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close))
            ],
          )
        ],
      ),
      children: [
        Container(
          color: Colors.grey[300],
          height: 300,
          child: FittedBox(
            fit: BoxFit.contain,
            clipBehavior: Clip.hardEdge,
            child: Image.memory(
              Base64Decoder().convert(product.image),
            ),
          ),
        ),
        Container(
            width: 200,
            height: 100,
            child: Container(
              child: Material(
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('Description: '), Text(product.description)],
                ),
              ),
            ))

        // Padding(
        //   padding: EdgeInsets.all(4),
        //   child: Row(
        //     children: [
        //       Tooltip(
        //           message: "Stock",
        //           child: Row(
        //             children: [
        //               Icon(Icons.filter_none),
        //               Text(product.inStock.toString())
        //             ],
        //           ))
        //     ],
        //   ),
        // )
      ],
    );
    // return SizedBox(
    //     width: 300,
    //     height: 300,
    //     child: FittedBox(
    //         fit: BoxFit.contain,
    //         child: Column(
    //           children: [
    //             Container(
    //                 child: Stack(
    //               children: [
    //                 Container(
    //                   height: 300,
    //                   color: Colors.black,
    //                   child: Image.memory(
    //                     Base64Decoder().convert(product.image),
    //                   ),
    //                 ),
    //                 Container(
    //                     width: 300,
    //                     color: Theme.of(context).primaryColor,
    //                     child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text(product.name),
    //                           IconButton(
    //                               onPressed: () => Navigator.pop(context),
    //                               icon: Icon(Icons.close))
    //                         ])),
    //               ],
    //             )),
    //             // Row(
    //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //   children: [Text(product.name), Text('R${product.price}')],
    //             // ),
    //             // Divider(),
    //             // Container(child: Text(product.description))
    //           ],
    //         )));
  }
}
