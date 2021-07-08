import 'dart:convert';

// import 'package:skate/Models/Category.dart';
// import 'package:skate/Models/Order.dart';
// import 'package:skate/Services/SharedPreferenceService.dart';
// import 'package:skate/ViewModels/AppViewModel.dart';
// import 'package:skate/Views/CartView.dart';
// import 'package:skate/Widgets/CategoryTile.dart';
// import 'package:skate/Widgets/MyAppBar.dart';
// import 'package:skate/Widgets/NavigationDrawer.dart';
// import 'package:skate/Widgets/ProductTile.dart';
// import 'package:skate/Models/User.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/Dialogs/ConfirmDialog.dart';

import 'package:flutter/material.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'package:skate/Providers/CartProvider.dart';
import 'package:skate/Widgets/Buttons/AddToCartButton.dart';
import 'package:skate/Widgets/Buttons/CartViewButton.dart';

class ProductView extends StatefulWidget {
  final String product;

  const ProductView({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductView> {
  Product _product;
  final TextStyle headingStyle = TextStyle(
    fontSize: 30.0,
  );

  final TextStyle subheadingStyle = TextStyle(
    fontSize: 24.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    ThemeData theme = Theme.of(context);

    ProfileService profileService = Provider.of<ProfileService>(context);
    if (!profileService.authorized) {
      return Text("Unauthorized");
    }

    var Args = ModalRoute.of(context)?.settings.arguments as Map ?? {};

    String id = Args['id'];
    return Scaffold(
      // appBar: myAppBar(context, '/product'),
      appBar: AppBar(
        leading: BackButton(),
        actions: [CartViewButton()],
      ),
      body: BaseQueryWidget(
        query: """{
          product(id: "$id") {
            id
            price
            name
            category
            description
            image
            size
            stock {
              size,
              value
            }
          }

        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          _product = Product.fromJson(result.data['product']);
          List<OrderProduct> inCart = cart.products
              .where((element) => element.product.id == _product.id)
              .toList();
          return Center(
              child: SizedBox(
                  width: 400,
                  child: ListView(
                    // padding: EdgeInsets.all(20.0),
                    children: [
                      SizedBox(
                        width: 400,
                        height: 400,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.memory(
                            Base64Decoder().convert(_product.image),
                          ),
                        ),
                      ),

                      inCart.isEmpty
                          ? Container()
                          : Text("In Cart", style: theme.textTheme.headline6),
                      ...inCart
                          .map((e) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.size),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() => e.value++);
                                          },
                                          icon: Icon(Icons.add)),
                                      SizedBox(child: Text(e.value.toString())),
                                      IconButton(
                                          onPressed: () {
                                            if (e.value == 1) {
                                              showDialog(
                                                  context: context,
                                                  builder: (c) => ConfirmDialog(
                                                      message:
                                                          "Remove from cart?",
                                                      onAccept: () {
                                                        setState(() => cart
                                                            .removeFromCart(e));
                                                      }));
                                            } else
                                              setState(() => e.value--);
                                          },
                                          icon: Icon(Icons.remove))
                                    ],
                                  )
                                ],
                              ))
                          .toList(),
                      AddToCartButton(
                          product: _product,
                          addToCart: (e) =>
                              setState(() => cart.addProductToCart(e))),
                      Text(_product.name, style: headingStyle),

                      // Row(
                      //   children: [
                      //     DropdownButton(
                      //         items: _product.stock.keys
                      //             .map((e) => DropdownMenuItem(child: Text(e)))
                      //             .toList())
                      //   ],
                      // ),
                      Text(_product.description),
                      Chip(label: Text(_product.category)),
                    ],
                  )));
        },
      ),
    );
  }
}
