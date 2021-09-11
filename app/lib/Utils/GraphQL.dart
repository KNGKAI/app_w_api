import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:skate/Services/Api.dart';

class GraphQL {
  static Link link;
  static HttpLink httpLink = HttpLink("${Api.host}gql");

  static void setToken(String token) {
    AuthLink authLink = AuthLink(getToken: () async => 'Bearer ' + token);
    GraphQL.link = authLink.concat(GraphQL.httpLink);
  }

  static void removeToken() {
    GraphQL.link = null;
  }

  static Link getLink() {
    return GraphQL.link != null ? GraphQL.link : GraphQL.httpLink;
  }

  static final policies = Policies(
    fetch: FetchPolicy.noCache,
  );

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: getLink(),
      cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(
        watchQuery: policies,
        query: policies,
        mutate: policies,
      ),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: getLink(),
    );
  }
}
