import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/CartProvider.dart';

class CartView extends StatefulWidget {
  const CartView({Key key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    List<Widget> CartListItems = cart.getAll().entries.map((ci) {
      return ListTile(
          title: Text(ci.key.name),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 100,
                  child: Padding(
                    child: Text('${ci.value} x R${ci.key.price}'),
                    padding: EdgeInsets.all(4),
                  )),
              Container(
                width: 100,
                child: Padding(
                  child: Text('R${ci.value * ci.key.price}'),
                  padding: EdgeInsets.all(4),
                ),
              )
            ],
          ));
    }).toList();
    CartListItems.add(ListTile(title: Divider()));
    CartListItems.add(ListTile(
        title: Text("Total:"),
        trailing: Container(
          width: 100,
          child: Text('R${cart.getCost()}'),
        )));

    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (cnt) => SimpleDialog(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Confirm clear cart...")),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SimpleDialogOption(
                                        child: Text("Yes"),
                                        onPressed: () => setState(() {
                                          cart.clearCart();
                                          Navigator.pop(context);
                                        }),
                                      ),
                                      SimpleDialogOption(
                                        child: Text("No"),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  )
                                ],
                              ));
                    },
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "Clear cart",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      // To-Do
                    },
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          "Checkout",
                          style: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
            Expanded(
              child: cart.getAll().isEmpty
                  ? Center(child: Text("Cart is empty"))
                  : ListView(
                      children: CartListItems,
                    ),
            )
          ],
        ));
  }
}
