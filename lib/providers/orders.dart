import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get order {
    return [..._orders];
  }

  void addOrders(
    List<CartItem> cartProducts,
    double total,
  ) {
    _orders.insert(
      0,
      OrderItems(
        id: DateTime.now().toString(),
        products: cartProducts,
        amount: total,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
