import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.white,
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: id,
                    );
                  },
                ),
                Consumer<ProductsProvider>(
                  builder: (ctx, prod, child) {
                    return IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctxAlert) => AlertDialog(
                            title: Text("Are you sure?"),
                            content: Text(
                              "Do you want to remove this product?",
                            ),
                            actions: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: FlatButton(
                                  splashColor: Colors.red.withOpacity(0.5),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: FlatButton(
                                  onPressed: () async {
                                    Navigator.of(ctxAlert).pop();
                                    try {
                                      await prod.deleteProduct(id);
                                    } catch (error) {
                                      print("$error snackbar");
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Deleting Failed!",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Yes",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
