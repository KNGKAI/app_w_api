import 'package:app/Models/Category.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';

import 'package:app/Widgets/ProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:app/Widgets/Product/ProductEditing.dart';

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
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();

          return Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        iconSize: 42,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return ProductEditing(
                                  product: Product.create(),
                                  categories:
                                      categories.map((e) => e.name).toList(),
                                  save: (p) async {
                                    bool ok =
                                        await productService.addProduct(p);
                                    if (!ok)
                                      showDialog(
                                          context: context,
                                          builder: (c) => AlertDialog(
                                                title:
                                                    Text("Couldnt create new"),
                                              ));
                                    else {
                                      Navigator.pop(context);
                                      refetch();
                                    }
                                  },
                                );
                              });
                        },
                        icon: Icon(Icons.add)),
                  ],
                ),
              ),
              Expanded(
                child: ProductWidget.list(products,
                    actionBuilder: (context, Product product) {
                  return [
                    IconButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (c) => AlertDialog(
                                    title: Text(
                                        'Confirm deletion of "${product.name}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          print("Yes delete it");
                                          bool ok = await productService
                                              .removeProduct(product);
                                          if (ok) refetch();
                                        },
                                        child: Text("Delete"),
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          print("No, nevermind");
                                          Navigator.pop(c);
                                        },
                                        child: Text("Abort"),
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green)),
                                      )
                                    ],
                                  ));
                        },
                        icon: Icon(Icons.delete_forever)),
                    IconButton(
                        onPressed: () {
                          print('Editing product: ${product.name}');
                          showDialog(
                              context: context,
                              builder: (c) {
                                return ProductEditing(
                                    product: product,
                                    categories:
                                        categories.map((e) => e.name).toList(),
                                    save: (p) async {
                                      bool ok =
                                          await productService.updateProduct(p);
                                      if (ok) {
                                        Navigator.pop(context);
                                        refetch();
                                        return;
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (c) => AlertDialog(
                                                title: Text("Failed to update"),
                                              ));
                                    });
                              });
                        },
                        icon: Icon(Icons.edit))
                  ];
                }),
              )
            ],
          );
        });
  }
}
    //     return ListView(
    //       padding: EdgeInsets.all(20.0),
    //       children: [
    //         Text("Categories:"),
    //         Column(
    //           children: categories.map((category) {
    //             TextEditingController nameController =
    //                 TextEditingController(text: category.name);
    //             return CategoryTile(
    //               category: category,
    //               onEdit: () async {
    //                 await showDialog(
    //                     context: context,
    //                     builder: (context) => AlertDialog(
    //                           title: Text("Edit Category"),
    //                           content: TextField(
    //                             controller: nameController,
    //                             onChanged: (value) => category.name = value,
    //                             decoration: InputDecoration(labelText: "Name"),
    //                           ),
    //                           actions: [
    //                             TextButton(
    //                               child: Text("Update"),
    //                               onPressed: () async {
    //                                 if (await productService
    //                                     .updateCategory(category)) {
    //                                   Navigator.pop(context);
    //                                   refetch();
    //                                 }
    //                               },
    //                             ),
    //                             TextButton(
    //                               child: Text("Cancel"),
    //                               onPressed: () => Navigator.pop(context),
    //                             )
    //                           ],
    //                         ));
    //               },
    //               onRemove: () async {
    //                 await showDialog(
    //                     context: context,
    //                     builder: (context) => AlertDialog(
    //                           title: Text("Remove Category"),
    //                           content: Text("Are you sure?"),
    //                           actions: [
    //                             TextButton(
    //                               child: Text("Remove"),
    //                               onPressed: () async {
    //                                 if (await productService
    //                                     .removeCategory(category)) {
    //                                   Navigator.pop(context);
    //                                   refetch();
    //                                 }
    //                               },
    //                             ),
    //                             TextButton(
    //                               child: Text("Cancel"),
    //                               onPressed: () => Navigator.pop(context),
    //                             )
    //                           ],
    //                         ));
    //               },
    //             );
    //           }).toList(),
    //         ),
    //         TextButton(
    //           child: Text("Add Category", style: TextStyle(color: Colors.blue)),
    //           onPressed: () async {
    //             Category category = Category.create();
    //             TextEditingController nameController =
    //                 TextEditingController(text: category.name);
    //             await showDialog(
    //                 context: context,
    //                 builder: (context) => AlertDialog(
    //                       title: Text("Add Category"),
    //                       content: TextField(
    //                         controller: nameController,
    //                         onChanged: (value) => category.name = value,
    //                         decoration: InputDecoration(labelText: "Name"),
    //                       ),
    //                       actions: [
    //                         TextButton(
    //                           child: Text("Add",
    //                               style: TextStyle(color: Colors.blue)),
    //                           onPressed: () async {
    //                             if (await productService
    //                                 .addCategory(category)) {
    //                               Navigator.pop(context);
    //                               refetch();
    //                             }
    //                           },
    //                         ),
    //                         TextButton(
    //                           child: Text("Cancel",
    //                               style: TextStyle(color: Colors.red)),
    //                           onPressed: () => Navigator.pop(context),
    //                         )
    //                       ],
    //                     ));
    //           },
    //         ),
    //         Text("Products:"),
    //         Column(
    //           children: products.map((product) {
    //             return ProductTile(
    //               product: product,
    //               onTap: () async {
    //                 AppViewModel.setId(product.id);
    //                 Navigator.of(context).pushNamed('/product/edit');
    //               },
    //             );
    //           }).toList(),
    //         ),
    //         TextButton(
    //           child: Text("Add Product", style: TextStyle(color: Colors.blue)),
    //           onPressed: () async {
    //             Product product = Product(
    //                 name: "",
    //                 description: "",
    //                 category: categories.first?.name ?? "",
    //                 size: "",
    //                 image: "",
    //                 inStock: 0,
    //                 price: 0);
    //             await showDialog(
    //                 context: context,
    //                 builder: (context) => AlertDialog(
    //                       title: Text("Add Product"),
    //                       content: ProductWidget.editor(
    //                           product: product,
    //                           categories:
    //                               categories.map((e) => e.name).toList()),
    //                       actions: [
    //                         TextButton(
    //                           child: Text("Add",
    //                               style: TextStyle(color: Colors.blue)),
    //                           onPressed: () async {
    //                             if (await productService.addProduct(product)) {
    //                               Navigator.pop(context);
    //                               refetch();
    //                             }
    //                           },
    //                         ),
    //                         TextButton(
    //                           child: Text("Cancel",
    //                               style: TextStyle(color: Colors.red)),
    //                           onPressed: () {
    //                             Navigator.pop(context);
    //                           },
    //                         )
    //                       ],
    //                     ));
    //           },
    //         ),
    //       ],
    //     );
//       },
//     );
//   }
// }
