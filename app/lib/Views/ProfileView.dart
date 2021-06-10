import 'package:app/Models/Category.dart';
import 'package:app/Models/Product.dart';
import 'package:app/Services/ProductService.dart';
import 'package:app/Widgets/BaseQueryWidget.dart';
import 'package:app/Widgets/CategoryTile.dart';
import 'package:app/Widgets/MyAppBar.dart';
import 'package:app/Widgets/ProductEditing.dart';
import 'package:app/Widgets/ProductTile.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/User.dart';
import 'package:app/Services/ProfileService.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    ProductService productService = Provider.of<ProductService>(context);
    if (!profileService.authorized) {
      return (Text("Unauthorized"));
    }
    return Scaffold(
      appBar: myAppBar(context, '/profile'),
      body: BaseQueryWidget(
        query: """{
          products {
            id
            price
            name
            category
            description
            image
            size
          }
          categories {
            id
            name
          }
        }""",
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          List<Product> products = result.data['products']
              .map<Product>((json) => Product.fromJson(json))
              .toList();
          List<Category> categories = result.data['categories']
              .map<Category>((json) => Category.fromJson(json))
              .toList();
          User user = profileService.user;
          TextEditingController usernameController = TextEditingController(text: user.username);
          TextEditingController emailController = TextEditingController(text: user.email);
          TextEditingController addressController = TextEditingController(text: user.address);
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircleAvatar(
                  // backgroundImage: FileImage(_image),
                  radius: 30,
                  child: Text(user.username.toUpperCase()[0]),
                ),
              ),
            ),
            Center(child: Text(user.username, style: TextStyle(fontSize: 20))),
            Center(child: Text(user.email, style: TextStyle(fontSize: 20))),
            TextButton(
              child: Text("Sign Out"),
              onPressed: () {
                profileService.signOutUser();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.lightBlue,
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.shopping_cart), text: "Cart",),
                        Tab(icon: Icon(Icons.format_align_left), text: "Stock"),
                        Tab(icon: Icon(Icons.settings), text: "Profile"),
                      ],
                    ),
                  ),
                  body: TabBarView(
                      children: [
                        ListView(
                          padding: EdgeInsets.all(20.0),
                          children: [],
                        ),
                        ListView(
                          padding: EdgeInsets.all(20.0),
                          children: [
                            Text("Categories:"),
                            Column(
                              children: categories.map((category) {
                                return CategoryTile(
                                  category: category,
                                  onEdit: () {

                                  },
                                  onRemove: () {

                                  },
                                );
                              }).toList(),
                            ),
                            TextButton(
                              child: Text("Add Category"),
                              onPressed: () async {
                                Category category = Category.create();
                                TextEditingController nameController = TextEditingController(text: category.name);
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Add Category"),
                                    content: TextField(
                                      controller: nameController,
                                      onChanged: (value) => category.name = value,
                                      decoration: InputDecoration(
                                        labelText: "Name"
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Update"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  )
                                );
                              },
                            ),
                            Text("Products:"),
                            Column(
                              children: products.map((product) {
                                return ProductTile(
                                  product: product,
                                  onTap: () async {
                                    Product cachedProduct = Product(
                                      name: product.name,
                                      description: product.description,
                                      category: product.category,
                                      price: product.price,
                                      size: product.name,
                                    );
                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Editing: ${product.name}"),
                                          content: ProductEditing(
                                              product: product,
                                              categories: categories.map((e) => e.name).toList()
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text("Update"),
                                              onPressed: () async {
                                                if (await productService.updateProduct(product)) {
                                                  Navigator.pop(context);
                                                  refetch();
                                                }
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                setState(() {
                                                  product = cachedProduct;
                                                });
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        )
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            TextButton(
                              child: Text("Add Product"),
                              onPressed: () {

                              },
                            ),
                          ],
                        ),
                        ListView( //Settings
                          padding: EdgeInsets.all(20.0),
                          children: [
                            Text("Profile:", textScaleFactor: 1.4),
                            TextField(
                              controller: usernameController,
                              onChanged: (value) => user.username = value,
                              decoration: InputDecoration(labelText: "Username"),
                            ),
                            TextField(
                              controller: emailController,
                              onChanged: (value) => user.email = value,
                              decoration: InputDecoration(labelText: "Email"),
                            ),
                            TextField(
                              controller: addressController,
                              onChanged: (value) => user.address = value,
                              decoration: InputDecoration(labelText: "Address"),
                            ),
                          ],
                        )
                      ]
                  ),
                )
              )
            )
          ]);
        },
      ),
    );
  }
}
