import 'package:flutter/material.dart';
import 'package:app/Models/Category.dart';

class CategoryChips extends StatefulWidget {
  final void Function(List<String>) onFilterUpdate;
  final List<String> categories, selectedCategories;
  const CategoryChips(
      {Key key,
      @required this.onFilterUpdate,
      this.categories,
      this.selectedCategories})
      : super(key: key);

  @override
  _CategoryChipsState createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.categories
          .map((c) => Padding(
                padding: EdgeInsets.all(4),
                child: FilterChip(
                    label: Text(c),
                    selected: widget.selectedCategories.contains(c),
                    onSelected: (v) {
                      setState(() {
                        if (widget.selectedCategories.contains(c))
                          widget.selectedCategories.remove(c);
                        else
                          widget.selectedCategories.add(c);
                        widget.onFilterUpdate(widget.selectedCategories);
                      });
                    }),
              ))
          .toList(),
    );
    ;
  }
}
