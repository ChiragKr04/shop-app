import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order-screen";

  Future<void> refreshOrders(BuildContext context) async {
    await Provider.of<Order>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
        ),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () => refreshOrders(context),
          child: FutureBuilder(
            future: Provider.of<Order>(context, listen: false).fetchOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  return Center(
                    child: Text("Error Occurred"),
                  );
                } else {
                  return Consumer<Order>(builder: (ctx, orderData, child) {
                    return ListView.builder(
                      itemCount: orderData.order.length,
                      itemBuilder: (ctx, index) {
                        return OrderItem(orderData.order[index]);
                      },
                    );
                  });
                }
              }
            },
          )),
    );
  }
}
