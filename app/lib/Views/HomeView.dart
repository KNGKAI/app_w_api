import 'dart:convert';
import 'dart:math';

import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/ViewModels/AppViewModel.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/Product/ProductGridTile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:skate/Widgets/Filter/CategoryChips.dart';
import 'package:skate/Widgets/ProductWidget.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  List<String> _selectedCategories, _categories = [];
  RangeValues _filterRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _categories = result.data['categories']
              .map<String>((json) => Category.fromJson(json).name)
              .toList();
          if (_selectedCategories == null) _selectedCategories = _categories;

          List<Product> products = result.data['products']
              .map<Product>((json) => Product.fromJson(json))
              .map<Product>((Product product) {
            // product.inStock -=
            //     cart.where((id) => product.id.compareTo(id) == 0).length;
            return product;
          }).toList();
          if (_selectedCategories != null) {
            products = products
                .where(
                    (product) => _selectedCategories.contains(product.category))
                .toList();
          }
          int horizontalCount = 2;
          double width =
              300; // MediaQuery.of(context).size.width / horizontalCount;
          return ListView(
            children: [
              CategoryChips(
                onFilterUpdate: (cat) =>
                    setState(() => _selectedCategories = cat),
                categories: _categories,
                selectedCategories: _selectedCategories,
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
                                  width: width,
                                  // onTap: () async {
                                  //   AppViewModel.setId(product.id);
                                  //   Navigator.of(context).pushNamed("/product");
                                  // },
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
