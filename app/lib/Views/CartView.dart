import 'package:app/Models/Category.dart';
import 'package:app/Models/Order.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/CategoryTile.dart';
import 'package:app/Widgets/MyAppBar.dart';
import 'package:app/Widgets/OrderTile.dart';
import 'package:app/Widgets/ProductEditing.dart';
import 'package:app/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<CartView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    if (!profileService.authorized) {
      return (Text("Unauthorized"));
    }
    ProductService productService = Provider.of<ProductService>(context);
    return BaseQueryWidget(
      query: """{
          products {
            id
            price
            name
            category
            description
            image
            size
            inStock
          }
        }""",
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        List<Product> products = result.data['products']
            .map<Product>((json) => Product.fromJson(json))
            .toList();
        print(productService.getCart().toString());
        List<Product> cart = productService.getCart()
            .map<Product>((id) => products.firstWhere((product) => product.id == id,
            orElse: () => Product(id: id, name: "none", price: 0, size: "none", category: "none")))
            .toList();
        return cart.isEmpty
            ? Center(child: Text("Nothing in your cart"))
            : ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Column(
              children: cart.map((product) => ListTile(
                title: Text(product.name + " - R" + product.price.toString()),
                subtitle: Text(product.size),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Remove from cart?"),
                          actions: [
                            TextButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                if (await productService.removeFromCart(product)) {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                            ),
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        )
                    );
                  },
                ),
              )).toList(),
            ),
            TextButton(
              child: Text("Place Order"),
              onPressed: () async {
                if (await productService.placeOrder(profileService.user)) {
                  setState(() { });
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Order Place"),
                      actions: [
                        TextButton(
                          child: Text("Okay"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    )
                  );
                }
              },
            )
          ],
        );
      },
    );
  }
}
