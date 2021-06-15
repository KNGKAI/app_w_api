import 'package:flutter/material.dart';
import 'package:app/Models/Category.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FilterBottomSheet extends StatefulWidget {
  final void Function(List<String> e) updateSelection;
  List<String> _selectedCategories = [];
  List<String> _categories = [];
  FilterBottomSheet(
      {Key key, @required Function(List<String> e) this.updateSelection})
      : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BaseQueryWidget(
      query: """{
          categories {
            name
          }
        }""",
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        List<Category> __categories = result.data['categories']
            .map<Category>((json) => Category.fromJson(json))
            .toList();
        widget._categories =
            __categories.map((category) => category.name).toList();
        if (widget._selectedCategories.isEmpty) {
          widget._selectedCategories = widget._categories;
        }

        return SizedBox(
            height: 250,
            child: Container(
                width: 200,
                child: ListView(
                    children: widget._categories.map((e) {
                  bool selected = widget._selectedCategories.contains(e);
                  return ListTile(
                    title: Text(e),
                    trailing: Icon(!selected
                        ? Icons.check_box_outline_blank
                        : Icons.check_box),
                    onTap: () => {
                      setState(() {
                        if (!selected)
                          widget._selectedCategories.add(e);
                        else
                          widget._selectedCategories.remove(e);
                        widget.updateSelection(widget._selectedCategories);
                      })
                    },
                  );
                }).toList())));
      },
    );
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
    //           // if (__selectedCategories == null) {
    //           //   __selectedCategories = _categories.toList();
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
