import 'dart:convert';
import 'dart:math';

import 'package:app/Models/Category.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/ViewModels/AppViewModel.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/ProductWidget.dart';
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
            description
            category
            size
            inStock
            image
            price
          }
          categories {
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          int minPrice = 0, maxPrice = 1;
          List<Product> products = result.data['products']
              .map<Product>((json) {
                Product p = Product.fromJson(json);
                minPrice = min(minPrice, p.price);
                maxPrice = max(maxPrice, p.price);
                return p;
              })
              .where((product) =>
                  (_selectedCategories.contains(product.category) &&
                      product.price >= minPrice &&
                      product.price <= maxPrice) ||
                  _selectedCategories.isEmpty)
              .toList();
          // ,
          List<Category> __categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          _categories = __categories.map((e) => e.name).toList();
          if (_selectedCategories.isEmpty) _selectedCategories = _categories;

          return Column(
            children: [
              CategoryChips(
                  categories: _categories,
                  selectedCategories: _selectedCategories,
                  onFilterUpdate: (ss) => setState(() {
                        _selectedCategories = ss;
                      })),
              Expanded(child: ProductWidget.grid(products))
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
