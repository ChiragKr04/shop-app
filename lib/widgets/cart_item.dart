import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  CartItem({
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.id,
    @required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
              "Do you want to remove the item from cart",
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
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
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
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
        child: ListTile(
          title: Text("$title"),
          subtitle: Text(
            "Total: \₹${(price * quantity).toStringAsFixed(2)}",
          ),
          trailing: Text(
            "x$quantity",
          ),
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Text(
                  "\₹${price.toStringAsFixed(2)}",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
