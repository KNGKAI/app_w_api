import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/ViewModels/AppViewModel.dart';
import 'package:skate/Views/CartView.dart';
import 'package:skate/Views/ProfileEditingView.dart';
import 'package:skate/Widgets/BaseQueryWidget.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/OrderTile.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:skate/Models/User.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class StockView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<StockView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductService productService = Provider.of<ProductService>(context);
    return BaseQueryWidget(
      query: """{
          products {
            id
            price
            name
            category
            description
            size
            stock {
              size
              value
            }
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
        List<Category> categories = result.data['categories']
            .map<Category>((json) => Category.fromJson(json))
            .toList();
        return ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Text("Categories:"),
            Column(
              children: categories.map((category) {
                TextEditingController nameController =
                    TextEditingController(text: category.name);
                return CategoryTile(
                  category: category,
                  onEdit: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Edit Category"),
                              content: TextField(
                                controller: nameController,
                                onChanged: (value) => category.name = value,
                                decoration: InputDecoration(labelText: "Name"),
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Update"),
                                  onPressed: () async {
                                    if (await productService
                                        .updateCategory(category)) {
                                      Navigator.pop(context);
                                      refetch();
                                    }
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ));
                  },
                  onRemove: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Remove Category"),
                              content: Text("Are you sure?"),
                              actions: [
                                TextButton(
                                  child: Text("Remove"),
                                  onPressed: () async {
                                    if (await productService
                                        .removeCategory(category)) {
                                      Navigator.pop(context);
                                      refetch();
                                    }
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ));
                  },
                );
              }).toList(),
            ),
            TextButton(
              child: Text("Add Category", style: TextStyle(color: Colors.blue)),
              onPressed: () async {
                Category category = Category.create();
                TextEditingController nameController =
                    TextEditingController(text: category.name);
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Add Category"),
                          content: TextField(
                            controller: nameController,
                            onChanged: (value) => category.name = value,
                            decoration: InputDecoration(labelText: "Name"),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Add",
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () async {
                                if (await productService
                                    .addCategory(category)) {
                                  Navigator.pop(context);
                                  refetch();
                                }
                              },
                            ),
                            TextButton(
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ));
              },
            ),
            Text("Products:"),
            Column(
              children: products.map((product) {
                return ProductTile(
                  product: product,
                  onTap: () async {
                    AppViewModel.setId(product.id);
                    Navigator.of(context).pushNamed('/product/edit');
                  },
                );
              }).toList(),
            ),
            TextButton(
              child: Text("Add Product", style: TextStyle(color: Colors.blue)),
              onPressed: () async {
                Product product = Product(
                    name: "",
                    description: "",
                    category: categories.first?.name ?? "",
                    // size: "",
                    image: "",
                    // inStock: 0,
                    price: 0);
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController nameController = TextEditingController(text: product.name);
                      TextEditingController descriptionController = TextEditingController(text: product.description);
                      TextEditingController priceController = TextEditingController(text: product.price.toString());
                      return AlertDialog(
                        title: Text("Add Product"),
                        content: Text("Product creation"),
                        actions: [
                          TextButton(
                            child: Text("Add",
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () async {
                              if (await productService.addProduct(product)) {
                                Navigator.pop(context);
                                refetch();
                              }
                            },
                          ),
                          TextButton(
                            child: Text("Cancel",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                );
              },
            ),
          ],
        );
      },
    );
  }
}
