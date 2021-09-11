import 'package:provider/single_child_widget.dart';
import 'package:skate/Services/Api.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Utils/GraphQL.dart';
import 'package:skate/Views/CartView.dart';
import 'package:skate/Views/ChatView.dart';
import 'package:skate/Views/HomeView.dart';
import 'package:skate/Views/LoginView.dart';
import 'package:skate/Views/OrderView.dart';
import 'package:skate/Views/ProfileView.dart';
import 'package:skate/Views/RegistrationView.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skate/Views/StockView.dart';

void main() async {
  print("Starting...");

  WidgetsFlutterBinding.ensureInitialized();
  Api api = Api();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
  ProfileService profileService = ProfileService(api: api);

  await sharedPreferenceService.init();
  await profileService.init();

  List<SingleChildWidget> providers = [
    Provider.value(value: api),
    ProxyProvider<Api, ProfileService>(
      update: (context, api, service) => profileService,
    ),
    ProxyProvider<Api, ProductService>(
      update: (context, api, service) => ProductService(api: api),
    ),
  ];

  MaterialApp materialApp = MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.comfortable,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => HomeView(),
      '/login': (context) => LoginView(),
      '/register': (context) => RegistrationView(),
      '/profile': (context) => ProfileView(),
      '/chat': (context) => ChatView(),
      '/cart': (context) => CartView(),
      '/stock': (context) => StockView(),
      '/order': (context) => OrderView(),
    },
  );

  MultiProvider multiProvider = MultiProvider(
    providers: providers,
    child: materialApp,
  );

  runApp(GraphQLProvider(
    client: GraphQL.client,
    child: multiProvider,
  ));
}
