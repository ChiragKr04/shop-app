import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Consumer<Cart>(
        builder: (ctx, cart, child) => Container(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(5),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        label: Text(
                          "\₹${cart.totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Consumer<Order>(
                        builder: (ctx, order, child) => RaisedButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            order.addOrders(
                              cart.items.values.toList(),
                              cart.totalAmount,
                            );
                            cart.clearCart();
                          },
                          child: Text(
                            "ORDER NOW",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, index) {
                    return ci.CartItem(
                      title: cart.items.values.toList()[index].title,
                      quantity: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price,
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
