import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailsScreen(this.title,this.price);
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String??"";
    final loadedProducts = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProducts.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedProducts.title),
                background: Hero(
                  tag: loadedProducts.id,
                  child: Image.network(
                    loadedProducts.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProducts.price}',
              style:  TextStyle(color: Colors.grey, fontSize: 20,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '\$${loadedProducts.description}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 20,)
                )
            ),
                const SizedBox(height: 800,)
          ]))
        ],
      ),
    );
  }
}
