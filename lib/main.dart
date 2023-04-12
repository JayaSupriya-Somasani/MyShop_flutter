import 'package:flutter/material.dart';
import 'package:my_shop/helpers/custom_route.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:my_shop/screens/user_product_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (ctx) =>Products('',"", [],),
              update: (ctx, auth, prevProducts) =>
                  Products(auth.token ?? '', auth.userId!,(prevProducts==null)?[]:prevProducts.items)),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) =>Orders("","" ,[]),
            update: (ctx, auth, previousOrders) => Orders(
              auth.token??'',auth.userId!,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) =>

              MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primarySwatch: Colors.deepPurple,
                    accentColor: Colors.deepOrange,
                    fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.iOS:CustomPageTransitionBuilder(),
                    TargetPlatform.android:CustomPageTransitionBuilder()
                  }
                )),
                home: auth.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState ==
                      ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen(),
                ),
                routes: {
                  ProductDetailsScreen.routeName: (ctx) =>
                      ProductDetailsScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductScreen.routeName: (ctx) => UserProductScreen(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen()
                },
              ),
        ));
  }
}
