import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  ProductsGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFav? productsData.favoriteItems: productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) =>
          ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(
                products[index].id,
                products[index].title,
                products[index].imageUrl
            ),
          ),
      itemCount: products.length,
    );
  }
}
