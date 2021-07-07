import 'dart:convert';
import 'dart:math';

import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/ViewModels/AppViewModel.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/ProductGridTile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:app/Views/RootView.dart';
import 'package:app/Widgets/Filter/CategoryChips.dart';
import 'package:app/Widgets/Filter/PriceRange.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  List<String> _selectedCategories = [];
  List<String> _categories = [];
  RangeValues _filterRange;

  @override
  Widget build(BuildContext context) {
    return RootView(
      body: BaseQueryWidget(
        query: """{
          products {
            id
            name
            category
            size
            stock {
              size
              value
            }
            image
            price
          }
          categories {
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          // List<String> cart = ProductService.getCart();
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          List<Product> products = result.data['products']
              .map<Product>((json) => Product.fromJson(json))
              .map<Product>((Product product) {
            // product.inStock -=
            //     cart.where((id) => product.id.compareTo(id) == 0).length;
            return product;
          }).toList();
          if (_selectedCategories != null) {
            products = products
                .where((product) =>
                    product.category.compareTo(_selectedCategories) == 0)
                .toList();
          }
          int horizontalCount = 2;
          double width = MediaQuery.of(context).size.width / horizontalCount;
          return ListView(
            children: [
              categories.isEmpty
                  ? Center(child: Text("No Categories Found!"))
                  : Container(
                      height: 60.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: categories.map((category) {
                          bool selected = _selectedCategories == category.name;
                          return Padding(
                            padding: EdgeInsets.all(15.0),
                            child: MaterialButton(
                              // padding: EdgeInsets.all(10.0),
                              color: selected ? Colors.blue : Colors.white38,
                              onPressed: () {
                                setState(() {
                                  if (selected) {
                                    _selectedCategories = null;
                                  } else {
                                    _selectedCategories = category.name;
                                  }
                                });
                              },
                              child: Text(category.name.toUpperCase(),
                                  style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
              products.isEmpty
                  ? Center(child: Text("No Products Found!"))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: (width + 40) *
                          (products.length / horizontalCount).ceil(),
                      child: GridView.count(
                        primary: false,
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: horizontalCount,
                        children: products
                            .map<Widget>((product) => ProductGridTile(
                                  product: product,
                                  onTap: () async {
                                    AppViewModel.setId(product.id);
                                    Navigator.of(context).pushNamed("/product");
                                  },
                                ))
                            .toList(),
                      ),
                    )
            ],
          );
          // ListView(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: categories.map((category) {
          //         bool selected = _selectedCategories.contains(category.name);
          //         return MaterialButton(
          //           color: selected ? Colors.blue : Colors.grey,
          //           onPressed: () {
          //             setState(() {
          //               if (selected) {
          //                 _selectedCategories.remove(category.name);
          //               } else {
          //                 _selectedCategories.add(category.name);
          //               }
          //             });
          //           },
          //           child: Text(category.name.toUpperCase(),
          //               style: TextStyle(
          //                   color: selected ? Colors.white : Colors.black)),
          //         );
          //       }).toList(),
          //     ),
          //     products.isEmpty
          //         ? Center(child: Text("No Products Found!"))
          //         : Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: (width + 40) * products.length / horizontalCount,
          //             child: GridView.count(
          //               primary: false,
          //               padding:
          //                   const EdgeInsets.only(left: 10, right: 10, top: 5),
          //               crossAxisSpacing: 10,
          //               mainAxisSpacing: 10,
          //               crossAxisCount: horizontalCount,
          //               children: products
          //                   .map<Widget>((product) => ProductTile(
          //                         product: product,
          //                         image: Image.memory(
          //                           Base64Decoder().convert(product.image),
          //                         ),
          //                         onTap: () async {
          //                           var result = await showDialog(
          //                               context: context,
          //                               builder: (BuildContext context) {
          //                                 return SimpleDialog(
          //                                   title: Text(
          //                                       "${product.name} - R${product.price.toString()}.00"),
          //                                   children: <Widget>[
          //                                     SizedBox(height: 10.0),
          //                                     Image.memory(
          //                                       Base64Decoder()
          //                                           .convert(product.image),
          //                                       width: width,
          //                                     ),
          //                                     SizedBox(height: 10.0),
          //                                     Row(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment
          //                                               .spaceAround,
          //                                       children: [
          //                                         MaterialButton(
          //                                             color: Colors.red,
          //                                             onPressed: () =>
          //                                                 Navigator.of(context)
          //                                                     .pop(),
          //                                             child: Text("Cancel",
          //                                                 style: TextStyle(
          //                                                     color: Colors
          //                                                         .white))),
          //                                         MaterialButton(
          //                                             color: Colors.green,
          //                                             onPressed: () =>
          //                                                 Navigator.of(context)
          //                                                     .pop(),
          //                                             child: Text("Add to cart",
          //                                                 style: TextStyle(
          //                                                     color: Colors
          //                                                         .white))),
          //                                       ],
          //                                     )
          //                                   ],
          //                                 );
          //                               });
          //                         },
          //                       ))
          //                   .toList(),
          //             ),
          //           )
          //   ],
          // );
        },
      ),
    );
  }
}
