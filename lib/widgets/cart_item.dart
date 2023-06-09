import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.productId,
      required this.title,
      required this.price,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
       return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you Sure?"),
                  content: Text("Do you want to remove item from cart"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop(false);
                    }, child: Text("No")),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop(true);
                    }, child: Text("Yes"))
                  ],
                ));
      },
      onDismissed: (direction) {
        print("product id $productId");
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: FittedBox(child: Text('\$$price'))),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
