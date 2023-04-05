import 'package:flutter/material.dart';
import 'package:my_shop/screens/user_product_screen.dart';

class UserProductItem extends StatelessWidget {

  final String title;
  final String imgUrl;
  const UserProductItem(this.title,this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imgUrl),),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.edit),color: Theme.of(context).primaryColor),
            IconButton(onPressed: (){}, icon: Icon(Icons.delete),color: Theme.of(context).errorColor,)
          ],
        ),
      ),
    );
  }
}
