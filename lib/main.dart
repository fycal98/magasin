import 'package:flutter/material.dart';
import 'screens/MainScreen.dart';
import 'screens/ProductScreen.dart';
import 'screens/OrderScreen.dart';
import 'screens/CardScreen.dart';
import 'package:provider/provider.dart';
import 'products.dart';
import 'package:magasin/Cards.dart';
import 'Orders.dart';
import 'screens/ManageProducts.dart';
import 'screens/editproduct.dart';
import 'screens/editproduct.dart';
import 'screens/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'authentication.dart';
import 'screens/loading.dart';
import 'screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              update: (context, value, oldvalue) =>
                  Products(value.Token, value.UserId)),
          ChangeNotifierProvider<Cards>(create: (context) => Cards()),
          ChangeNotifierProvider<Orders>(create: (context) => Orders())
        ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.purple,
            focusColor: Colors.purple,
            appBarTheme: AppBarTheme(
              color: Colors.purple,
              iconTheme: IconThemeData(color: Colors.black26.withOpacity(0.4)),
            ),
          ),
          initialRoute: HomeScreen.route,
          routes: {
            HomeScreen.route: (context) => HomeScreen(),
            MainScreen.route: (context) => MainScreen(),
            OrderScreen.route: (context) => OrderScreen(),
            ProductScreen.route: (context) => ProductScreen(),
            CardScreen.route: (context) => CardScreen(),
            ManageProduts.route: (context) => ManageProduts(),
            EditScreen.route: (context) => EditScreen(),
            LoginScreen.route: (context) => LoginScreen(),
          },
        ));
  }
}
