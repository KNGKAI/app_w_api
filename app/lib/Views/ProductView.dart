import 'dart:convert';
import 'dart:math';

import 'package:app/Models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/Views/RootView.dart';
import 'package:app/Providers/CartProvider.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  const ProductView({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    Cart cart = Provider.of<Cart>(context);

    return RootView(
      enableDrawer: false,
      body: Center(
          child: Container(
        width: 400,
        child: Column(children: [
          Container(
            width: 400,
            child: Image.memory(
              Base64Decoder().convert(product.image),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.blue[200],
            child: TextButton(
                child: Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Add to cart"),
                            Icon(Icons.add_shopping_cart)
                          ],
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(12)),
                onPressed: () {
                  print('Add ${product.name} to cart');
                  cart.addProductToCart(product);
                  print(cart.getProductsInCart());
                  Navigator.pop(context);
                }),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: Text(product.name)),
                        Text('R${product.price}.00')
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      width: 400,
                      height: 150,
                      child: Text(
                        product.description,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    )
                  ])))
        ]),
      )),

      // Container(
      //   child: Card(
      //       child: Column(
      //     children: [
      //       Expanded(
      //         child:
      //       ),
      //       Column(
      //         children: [
      //           Expanded(
      //               child: Padding(
      //                   padding: EdgeInsets.all(14),
      //                   child: Text(
      //                     product.name,
      //                   )))
      //         ],
      //       )
      //     ],
      //   )
      // child: Positioned(
      //     right: 20,
      //     top: 20,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         SizedBox(
      //             height: 400,
      //             width: 400,
      //             child: Positioned.fill(
      //                 child: Image.memory(
      //               Base64Decoder().convert(product.image),
      //               fit: BoxFit.cover,
      //             ))),
      //         Padding(
      //             padding: EdgeInsets.all(16),
      //             child: Column(
      //               children: [
      //                 Padding(
      //                     padding: EdgeInsets.all(8),
      //                     child: Row(
      //                       mainAxisAlignment:
      //                           MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Text(product.name),
      //                         Text('R${product.price}.00')
      //                       ],
      //                     ))
      //               ],
      //             )),
      //         Container(
      //           padding: EdgeInsets.all(16),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               Text(product.description),
      //               Row(
      //                 mainAxisSize: MainAxisSize.max,
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [Text("Catagory:"), Text(product.category)],
      //               ),
      //               IconButton(
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                   },
      //                   icon: Icon(Icons.close)),
      //             ],
      //           ),
      //         )
      //       ],
      //     ))

      // )(
      //     fit: BoxFit.scaleDown,
      //     child: Container(
      //         // margin: EdgeInsets.all(maxsize),
      //         color: Colors.white,
      //         padding: EdgeInsets.all(20),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Image.memory(
      //               Base64Decoder().convert(widget.product.image),
      //               width: maxsize,
      //             ),
      //           ],
      //         ))

      // child: Padding(
      //   padding: EdgeInsets.all(10.0),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       Expanded(
      //         child:
      //             Image.memory(Base64Decoder().convert(widget.product.image)),
      //       ),

      //     ],
      //   ),
      // ),
    );
  }
}
