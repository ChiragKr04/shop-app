import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order-screen";

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
        ),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.order.length,
        itemBuilder: (ctx, index) {
          return OrderItem(orderData.order[index]);
        },
      ),
    );
  }
}
