import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import './providers/orders.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/product_overview_screen.dart';
import './providers/products.dart';
import 'providers/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => Products()),
        ),
        ChangeNotifierProvider(
          create: ((context) => Cart()),
        ),
        ChangeNotifierProvider(
          create: ((context) => Orders()),
        ),
      ],
      child: ChangeNotifierProvider.value(
        value: Products(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Colors.purple,
              onPrimary: Colors.black,
              secondary: Colors.black,
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.redAccent,
              background: Colors.blue,
              onBackground: Colors.blueAccent,
              surface: Colors.white,
              onSurface: Colors.amberAccent,
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                fontFamily: "Lato",
              ),
              titleLarge: TextStyle(
                fontFamily: "Lato",
              ),
            ),
          ),
          home: ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: ((context) => CartScreen()),
            OrderScreen.routeName: ((context) => OrderScreen()),
            UserProductScreen.routeName: ((context) => UserProductScreen()),
            EditProductScreen.routeName: ((context) => EditProductScreen()),
          },
        ),
      ),
    );
  }
}
