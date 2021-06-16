import 'package:app/Models/Category.dart';

class Cart {
  final List<Category> _categories = [];

  List<Category> getCategories() {
    return _categories;
  }
}
