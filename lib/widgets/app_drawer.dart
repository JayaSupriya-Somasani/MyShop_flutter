import 'package:flutter/material.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello...."),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap:() => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
            onTap:() => Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Manage Products"),
            onTap:() => Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Products"),
            onTap:() => Navigator.of(context).pushReplacementNamed(EditProductScreen.routeName),
          ),
          // const Divider(),
        ],
      ),
    );
  }
}