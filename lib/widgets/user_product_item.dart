import 'package:flutter/material.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaf = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            icon: Icon(
              Icons.edit,
            ),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context).deleteProduct(id);
              } catch (e) {
                print(e);
                scaf.showSnackBar(SnackBar(content: Text("Deleting Failed!")));
              }
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          )
        ],
      ),
    );
  }
}
