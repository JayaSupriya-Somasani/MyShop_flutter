import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName="/user-products";

  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [IconButton(onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        }, icon: Icon(Icons.add))],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_,i) =>
              Column(
                children: [
                  UserProductItem(productsData.items[i].title, productsData.items[i].imageUrl),
                  Divider()
                ],
              ),
          itemCount:productsData.items.length,),
      ),
    );
  }
}
