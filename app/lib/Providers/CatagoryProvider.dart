import 'package:app/Models/Category.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class Cart {
  final List<Category> _categories = [];

  List<Category> getCategories() {
    return _categories;
  }
}
