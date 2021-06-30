import './Buttons/CartViewButton.dart';
import './Buttons/AddToCartButton.dart';
import 'package:flutter/material.dart';

class Buttons {
  static Widget cartViewButton() => CartViewButton();
  static Widget addToCartButton(product) => AddToCartButton(product: product);
}
