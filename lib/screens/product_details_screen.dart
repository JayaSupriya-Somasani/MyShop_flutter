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
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProducts = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProducts.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Hero(
                tag: loadedProducts.id,
                child: Image.network(
                  loadedProducts.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProducts.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
              '\$${loadedProducts.description}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ))
          ],
        ),
      ),
    );
  }
}
