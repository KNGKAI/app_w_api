import 'package:app/Widgets/Product/ProductGrid.dart';
import 'package:app/Widgets/Product/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:app/Widgets/Product/ProductEditing.dart';

class ProductWidget {
  static Widget grid(products) => ProductGrid(products: products);

  static Widget list(products, {actionBuilder}) => ProductList(
        products: products,
        actionBuilder: actionBuilder,
      );
  static Widget editor({product, List<String> categories}) => ProductEditing(
        product: product,
        categories: categories,
      );
}
