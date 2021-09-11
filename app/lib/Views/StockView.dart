
import 'package:skate/Base/BaseViewModel.dart';
import 'package:skate/Base/BaseViewWidget.dart';
import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Base/BaseQueryWidget.dart';
import 'package:skate/Widgets/CategoryTile.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/ProductEditing.dart';
import 'package:skate/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
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
    return BaseViewWidget(
      model: BaseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: myAppBar(context, '/stock'),
        body: model.busy
            ? Center(child: CircularProgressIndicator())
            : BaseQueryWidget(
                query: """{
                  products {
                    id
                    price
                    name
                    category {
                      id
                      name
                    }
                    description
                    size
                    image
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
                                          onChanged: (value) =>
                                              category.name = value,
                                          decoration: InputDecoration(
                                              labelText: "Name"),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("Update"),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              model.setBusy(true);
                                              APIResponse response =
                                                  await productService
                                                      .updateCategory(category);
                                              if (response.success) {
                                                refetch();
                                              } else {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text("Error"),
                                                          content: Text(
                                                              response.message),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("OK"),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            )
                                                          ],
                                                        ));
                                              }
                                              model.setBusy(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                              Navigator.pop(context);
                                              model.setBusy(true);
                                              APIResponse response =
                                                  await productService
                                                      .removeCategory(category);
                                              if (response.success) {
                                                refetch();
                                              } else {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text("Error"),
                                                          content: Text(
                                                              response.message),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("OK"),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            )
                                                          ],
                                                        ));
                                              }
                                              model.setBusy(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ));
                            },
                          );
                        }).toList(),
                      ),
                      TextButton(
                        child: Text("Add Category",
                            style: TextStyle(color: Colors.blue)),
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
                                      onChanged: (value) =>
                                          category.name = value,
                                      decoration:
                                          InputDecoration(labelText: "Name"),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Add",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          model.setBusy(true);
                                          APIResponse response =
                                              await productService
                                                  .addCategory(category);
                                          if (response.success) {
                                            refetch();
                                          } else {
                                            await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text("Error"),
                                                      content: Text(
                                                          response.message),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("OK"),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                        )
                                                      ],
                                                    ));
                                          }
                                          model.setBusy(false);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Cancel",
                                            style:
                                                TextStyle(color: Colors.red)),
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
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Edit Product"),
                                      content: Container(
                                        height: 1024,
                                        width: 1024,
                                        child: ProductEditing(
                                            product: product,
                                            categories: categories),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("Update",
                                              style: TextStyle(
                                                  color: Colors.blue)),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            APIResponse response =
                                                await productService
                                                    .addProduct(product);
                                            if (response.success) {
                                              refetch();
                                            } else {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text(
                                                            response.message),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("OK"),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          )
                                                        ],
                                                      ));
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Cancel",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            onRemove: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Remove Product"),
                                        content: Text("Are you sure?"),
                                        actions: [
                                          TextButton(
                                            child: Text("Remove"),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              model.setBusy(true);
                                              APIResponse response =
                                                  await productService
                                                      .removeProduct(product);
                                              if (response.success) {
                                                refetch();
                                              } else {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text("Error"),
                                                          content: Text(
                                                              response.message),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("OK"),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            )
                                                          ],
                                                        ));
                                              }
                                              model.setBusy(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ));
                            },
                          );
                        }).toList(),
                      ),
                      TextButton(
                        child: Text("Add Product",
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () async {
                          Product product = Product(
                              name: "",
                              description: "",
                              category:
                                  categories.first ?? Category(name: "None"),
                              image: "",
                              stock: [],
                              price: 0);
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Add Product"),
                                  content: Container(
                                    height: 1024,
                                    width: 1024,
                                    child: ProductEditing(
                                        product: product,
                                        categories: categories),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text("Add",
                                          style: TextStyle(color: Colors.blue)),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        APIResponse response =
                                            await productService
                                                .addProduct(product);
                                        if (response.success) {
                                          refetch();
                                        } else {
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text("Error"),
                                                    content:
                                                        Text(response.message),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("OK"),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                      )
                                                    ],
                                                  ));
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
                              });
                        },
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
