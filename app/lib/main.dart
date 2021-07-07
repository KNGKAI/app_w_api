import 'package:skate/Services/Api.dart';
import 'package:skate/Services/ProductService.dart';
import 'package:skate/Services/ProfileService.dart';
import 'package:skate/Services/SharedPreferenceService.dart';
import 'package:skate/Views/HomeView.dart';
import 'package:skate/Views/LoginView.dart';
import 'package:skate/Views/RegistrationView.dart';
import 'package:skate/Views/SplashView.dart';

import 'package:skate/Views/ProductView.dart';
import 'package:skate/Views/CartView.dart';
// import 'package:skate/Views/OrderView.dart';
// import 'package:skate/Views/ProfileView.dart';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skate/Providers/CartProvider.dart';

void main() async {
  print("Starting...");
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceService().init();

  final policies = Policies(
    fetch: FetchPolicy.noCache,
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: HttpLink('https://012sktate-server.azurewebsites.net/graphql/'),
      // link: HttpLink('http://localhost:8008/graphql'),
      cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(
        watchQuery: policies,
        query: policies,
        mutate: policies,
      ),
    ),
  );

  runApp(GraphQLProvider(
    client: client,
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: Api()),
        Provider.value(value: Cart()),
        ProxyProvider<Api, ProfileService>(
          update: (context, api, service) => ProfileService(api: api),
        ),
        ProxyProvider<Api, ProductService>(
          update: (context, api, service) => ProductService(api: api),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.comfortable,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashView(),
          '/home': (context) => HomeView(),
          '/login': (context) => LoginView(),
          '/register': (context) => RegistrationView(),
          // '/profile': (context) => ProfileView(),
          '/cart': (context) => CartView(),
          // '/orders': (context) => OrderView(),
          '/product': (context) => ProductView()
          // '/product/edit': (context) => ProductEditingView(),
        },
      ),
    );
  }
}
