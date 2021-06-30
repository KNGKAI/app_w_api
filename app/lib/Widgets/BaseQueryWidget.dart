import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BaseQueryWidget<T extends ChangeNotifier> extends StatefulWidget {
  final String query;
  final Function(QueryResult, {Future<QueryResult> Function(FetchMoreOptions) fetchMore, Future<QueryResult> Function() refetch}) builder;

  BaseQueryWidget({
    @required this.query,
    @required this.builder,
    Key key}) : super(key: key);

  _BaseQueryWidgetState<T> createState() => _BaseQueryWidgetState<T>();
}

class _BaseQueryWidgetState<T extends ChangeNotifier> extends State<BaseQueryWidget<T>> {
  @override
  Widget build(BuildContext context) {
    print("Query:");
    print(widget.query);
    return Query(
      options: QueryOptions(
        document: gql(widget.query),
      ),
      builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore})  {
        if (result.hasException) {
          print("Error:");
          print(result.exception.toString());
          return Center(
            child: Column(
              children: [
                Text(result.exception.toString()),
                TextButton(
                  onPressed: () => refetch(),
                  child: Text("Retry", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                )
              ],
            ),
          );
        }

        if (result.isLoading) {
          print("Fetching...");
          return Center(child: CircularProgressIndicator());
        } else {
          print("Result:");
          print(result.data.toString());
        }

        return widget.builder(result, refetch: refetch, fetchMore: fetchMore);
      }
    );
  }
}
