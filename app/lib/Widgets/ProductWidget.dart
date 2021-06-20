import 'package:app/Widgets/Product/ProductGrid.dart';
import 'package:app/Widgets/Product/ProductList.dart';
import 'package:flutter/material.dart';

class ProductWidget {
  static Widget grid(products) => ProductGrid(products: products);
  static Widget list(products, {actionBuilder}) => ProductList(
        products: products,
        actionBuilder: actionBuilder,
      );
}
