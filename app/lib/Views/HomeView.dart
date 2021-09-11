import 'dart:convert';

import 'package:skate/Base/BaseViewModel.dart';
import 'package:skate/Base/BaseViewWidget.dart';
import 'package:skate/Models/Category.dart';
import 'package:skate/Models/Order.dart';
import 'package:skate/Models/Product.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:skate/ViewModels/AppViewModel.dart';
import 'package:skate/Base/BaseQueryWidget.dart';
import 'package:skate/Widgets/MyAppBar.dart';
import 'package:skate/Widgets/ProductGridTile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skate/Widgets/ProductImage.dart';
import 'package:skate/Widgets/ProductOrder.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  List<String> _selectedCategories, _categories = [];
  RangeValues _filterRange;

  @override
  Widget build(BuildContext context) {
    ProductService productService = Provider.of<ProductService>(context);

    return BaseViewWidget(
      model: BaseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: myAppBar(context, '/home'),
        body: model.busy
            ? Center(child: CircularProgressIndicator())
            : BaseQueryWidget(
                query: """{
                  products {
                    id
                    name
                    description
                    category {
                      id
                      name
                    }
                    size
                    stock {
                      size
                      value
                    }
                    image
                    price
                  }
                  categories {
                    id
                    name
                  }
                }""",
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  // List<String> cart = ProductService.getCart();
                  List<Category> categories = [Category(name: "All")];
                  categories.addAll(result.data['categories']
                      .map<Category>((json) => Category.fromJson(json)));
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
                            product.category.name
                                .compareTo(_selectedCategories) ==
                            0)
                        .toList();
                  }
                  int horizontalCount =
                      MediaQuery.of(context).size.width ~/ 256;
                  double width =
                      MediaQuery.of(context).size.width / horizontalCount;
                  return ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Filter: "),
                          DropdownButton(
                            value: _selectedCategories ?? "All",
                            items: categories
                                .map((category) => DropdownMenuItem(
                                      child: Text(category.name),
                                      value: category.name,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategories =
                                    value == "All" ? null : value;
                              });
                            },
                          )
                        ],
                      ),
                      products.isEmpty
                          ? Center(child: Text("No Products Found!"))
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: (width + 40) *
                                  (products.length / horizontalCount).ceil(),
                              child: GridView.count(
                                primary: false,
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: horizontalCount,
                                children: products
                                    .map<Widget>((product) => ProductGridTile(
                                          product: product,
                                          onTap: () async {
                                            // AppViewModel.setId(product.id);
                                            // Navigator.of(context)
                                            //     .pushNamed("/product");
                                            bool updated = await Navigator.push(
                                                context,
                                                MaterialPageRoute<bool>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ProductView(
                                                              product: product),
                                                ));
                                            if (updated) {
                                              refetch();
                                            }
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class ProductView extends StatefulWidget {
  final Product product;

  const ProductView({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    ProductService productService = Provider.of<ProductService>(context);
    bool inStock = widget.product.stock.any((stock) => stock.value > 0);
    bool landscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
    return BaseViewWidget(
        model: BaseViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(widget.product.category.name),
              ),
              body: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  Container(
                    width: landscape ? 512 : null,
                    height: landscape ? 512 : null,
                    child: ProductImage(
                      product: widget.product,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                          color: inStock ? Colors.green : Colors.grey,
                          onPressed: () async {
                            if (!profileService.authorized) {
                              return;
                            }
                            if (inStock) {
                              OrderProduct order = OrderProduct(
                                product: widget.product,
                                size: widget.product.stock
                                    .firstWhere((stock) => stock.value > 0)
                                    .size,
                                value: 1,
                              );
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Add to cart"),
                                        content: ProductOrder(order: order),
                                        actions: [
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          TextButton(
                                            child: Text("Add"),
                                            onPressed: () async {
                                              model.setBusy(true);
                                              if (await productService
                                                  .addToCart(order)) {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: Text(
                                                                  "Added to cart"),
                                                              actions: [
                                                                TextButton(
                                                                    child: Text(
                                                                        "Okay"),
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop())
                                                              ],
                                                            ));
                                                Navigator.of(context).pop();
                                              }
                                              model.setBusy(false);
                                            },
                                          )
                                        ],
                                      ));
                            }
                            setState(() {
                              // ???????
                            });
                          },
                          child: Text(inStock ? "Add to cart" : "Out of Stock",
                              style: TextStyle(color: Colors.white))),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(widget.product.name,
                      style: TextStyle(
                        fontSize: 30.0,
                      )),
                  Text("R${widget.product.price}",
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  Text(widget.product.stock
                      .map((stock) => stock.size)
                      .toList()
                      .toString()),
                  Text(widget.product.description)
                ],
              ),
            ));
  }
}
