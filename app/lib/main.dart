import 'package:app/Services/Api.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:app/Services/SharedPreferenceService.dart';
import 'package:app/Views/HomeView.dart';
import 'package:app/Views/LoginView.dart';
import 'package:app/Views/ProfileView.dart';
import 'package:app/Views/RegistrationView.dart';
import 'package:app/Views/SplashView.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

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
          primarySwatch: Colors.lightBlue,
          visualDensity: VisualDensity.comfortable,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashView(),
          '/home': (context) => HomeView(),
          '/login': (context) => LoginView(),
          '/register': (context) => RegistrationView(),
          '/profile': (context) => ProfileView(),
        },
      ),
    );
  }
}
