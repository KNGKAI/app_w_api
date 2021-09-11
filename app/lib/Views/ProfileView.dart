import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';

import 'package:skate/Widgets/Order/OrderList.dart';

import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';

import 'package:skate/Widgets/Settings.dart';
import 'package:skate/Widgets/ProductWidget.dart';
import 'package:skate/Widgets/OrderWidget.dart';
import 'package:skate/Widgets/Product/ProductEditing.dart';
import 'package:skate/Widgets/Filter/CategoryChips.dart';

import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:skate/Views/AdminView.dart';

import 'package:provider/provider.dart';
import 'package:skate/Providers/CartProvider.dart';
import 'package:skate/Views/RootView.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    ProductService productService = Provider.of<ProductService>(context);
    Cart cart = Provider.of<Cart>(context);

    // List<Widget> CartListItems = cart.getAll().entries.map((ci) {
    //   return ListTile(
    //       title: Text(ci.key.name),
    //       trailing: Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Container(
    //               width: 100,
    //               child: Padding(
    //                 child: Text('${ci.value} x R${ci.key.price}'),
    //                 padding: EdgeInsets.all(4),
    //               )),
    //           Container(
    //             width: 100,
    //             child: Padding(
    //               child: Text('R${ci.value * ci.key.price}'),
    //               padding: EdgeInsets.all(4),
    //             ),
    //           )
    //         ],
    //       ));
    // }).toList();
    // CartListItems.add(ListTile(title: Divider()));
    // CartListItems.add(ListTile(
    //     title: Text("Total:"),
    //     trailing: Container(
    //       width: 100,
    //       child: Text('R${cart.getCost()}'),
    //     )));

    if (!profileService.authorized) {
      return (Text("Unauthorized"));
    }
    return RootView(
      body: BaseQueryWidget(
        query: """{
          orders {
            id
            product {
              id
              price
              name
              category
              description
              size
              inStock  
            }
            user {
              id

            }
            reference
            status
          }
          products {
            id
            price
            name
            category
            description
            size
            inStock
            image
          }
          categories {
            id
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          List<Product> products = result.data['products']
              .map<Product>((json) => Product.fromJson(json))
              .toList();

          List<Order> orders = result.data['orders']
              .map<Order>((json) => Order.fromJson(json))
              .toList();
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          User user = profileService.user;

          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircleAvatar(
                  // backgroundImage: FileImage(_image),
                  radius: 30,
                  child: Text(user.username.toUpperCase()[0]),
                ),
              ),
            ),
            Center(child: Text(user.username, style: TextStyle(fontSize: 20))),
            Center(child: Text(user.email, style: TextStyle(fontSize: 20))),
            TextButton(
              child: Text("Sign Out"),
              onPressed: () {
                profileService.signOutUser();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
            Expanded(
                child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.lightBlue,
                        automaticallyImplyLeading: false,
                        bottom: TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(Icons.shopping_cart),
                              text: "Orders",
                            ),
                            Tab(
                                icon: Icon(Icons.format_align_left),
                                text: "Stock"),
                            Tab(icon: Icon(Icons.settings), text: "Profile"),
                          ],
                        ),
                      ),
                      body: TabBarView(children: [
                        OrderWidget.view(),
                        StockView(),
                        // children: [
                        // ListView(
                        //   padding: EdgeInsets.all(20.0),
                        //   children: [],
                        // ),
                        // ListView(
                        //   padding: EdgeInsets.all(20.0),
                        //   children: [
                        //     Text("Categories:"),
                        //     Column(
                        //       children: categories.map((category) {
                        //         return CategoryTile(
                        //           category: category,
                        //           onEdit: () {},
                        //           onRemove: () {},
                        //         );
                        //       }).toList(),
                        //     ),
                        //     TextButton(
                        //       child: Text("Add Category"),
                        //       onPressed: () async {
                        //         Category category = Category.create();
                        //         TextEditingController nameController =
                        //             TextEditingController(text: category.name);
                        //         await showDialog(
                        //             context: context,
                        //             builder: (context) => AlertDialog(
                        //                   title: Text("Add Category"),
                        //                   content: TextField(
                        //                     controller: nameController,
                        //                     onChanged: (value) =>
                        //                         category.name = value,
                        //                     decoration: InputDecoration(
                        //                         labelText: "Name"),
                        //                   ),
                        //                   actions: [
                        //                     TextButton(
                        //                       child: Text("Update"),
                        //                       onPressed: () async {
                        //                         Navigator.pop(context);
                        //                       },
                        //                     ),
                        //                     TextButton(
                        //                       child: Text("Cancel"),
                        //                       onPressed: () =>
                        //                           Navigator.pop(context),
                        //                     )
                        //                   ],
                        //                 ));
                        //       },
                        //     ),
                        //     Text("Products:"),

                        //     TextButton(
                        //       child: Text("Add Product"),
                        //       onPressed: () {},
                        //     ),
                        //   ],
                        // ),
                        Settings()
                      ]),
                    )))
          ]);
        },
      ),
    );
  }
}
