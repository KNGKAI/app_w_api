import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skate/Providers/CartProvider.dart';
import 'package:skate/Services/ProfileService.dart';

import 'package:skate/Widgets/Dialogs/ConfirmDialog.dart';
import 'package:skate/Widgets/Dialogs/InfoDialog.dart';

class CartView extends StatefulWidget {
  const CartView({Key key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    ProfileService pf = Provider.of<ProfileService>(context);

    Cart cart = Provider.of<Cart>(context);
    ThemeData theme = Theme.of(context);
    num totalPrice = 0;

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (c) => ConfirmDialog(
                              message: 'Clear cart?',
                              onAccept: () =>
                                  setState(() => cart.clearCart()))),
                      child: Text("Clear Cart", style: theme.textTheme.button)),
                  TextButton(
                      onPressed: () async {
                        if (await cart.checkout(pf.user)) {
                          showDialog(
                              context: context,
                              builder: (c) =>
                                  InfoDialog(message: "Order has been placed"));
                        } else {
                          showDialog(
                              context: context,
                              builder: (c) =>
                                  InfoDialog(message: "Could not place order"));
                        }
                      },
                      child: Text("Checkout", style: theme.textTheme.button))
                ],
              ),
            ),
            Divider(),
            cart.products.isEmpty
                ? Center(
                    child: Text("Cart is empty"),
                  )
                : Table(
                    children: [
                      TableRow(children: [
                        // Coloumn Headding
                        Text(
                          "Product",
                          style: theme.textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        Text("Size",
                            style: theme.textTheme.headline6,
                            textAlign: TextAlign.center),
                        Text("Price",
                            style: theme.textTheme.headline6,
                            textAlign: TextAlign.center),
                        Text("Quantity",
                            style: theme.textTheme.headline6,
                            textAlign: TextAlign.center),
                        Text("Totals",
                            style: theme.textTheme.headline6,
                            textAlign: TextAlign.center),
                      ]),
                      ...cart.products.map((e) {
                        // Cart Rows
                        totalPrice += e.value * e.product.price;
                        return TableRow(children: [
                          Text(e.product.name),
                          Text(e.size),
                          Text(e.product.price.toString()),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => setState(() => e.value++),
                                  icon: Icon(Icons.add)),
                              Text(e.value.toString()),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (e.value == 1)
                                        cart.removeFromCart(e);
                                      else
                                        e.value--;
                                    });
                                  },
                                  icon: Icon(e.value == 1
                                      ? Icons.delete
                                      : Icons.remove)),
                            ],
                          ),
                          Text((e.value * e.product.price).toString())
                        ]);
                      }).toList()
                    ],
                  ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(14),
                  child:
                      Text('R${totalPrice}', style: theme.textTheme.headline5),
                )
              ],
            )
          ],
        ));
  }
}
