import 'package:flutter/material.dart';
import 'package:app/Models/Category.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key key}) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<Category> _selectedCategories = [];
  List<Category> _categories = [];

  @override
  Widget build(BuildContext context) {
    return Column();
    // return Column(
    //   children: [
    //     Title(
    //       child: Text("Catagories"),
    //       color: Colors.black,
    //     ),
    //     BaseQueryWidget(
    //         query: """{
    //       categories {
    //         name
    //       }
    //     }""",
    //         builder: (QueryResult result,
    //             {VoidCallback refetch, FetchMore fetchMore}) {
    //           _categories = result.data['categories']
    //               .map<Category>((json) => Category.fromJson(json))
    //               .toList();
    //           // if (_selectedCategories == null) {
    //           //   _selectedCategories = _categories.toList();
    //           // }
    //           print(_categories);

    //           List<Widget> listChildren = _categories
    //               .map((e) => ListTile(title: Text(e.name)))
    //               .toList();

    //           return SizedBox(
    //               height: 300,
    //               child: Column(children: [
    //                 Expanded(
    //                     child: ListView(
    //                   children: _categories.isEmpty
    //                       ? [Text("No catagories")]
    //                       : listChildren,
    //                 ))
    //               ]));
    //         })
    //   ],
    // );
  }
}
