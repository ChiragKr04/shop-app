import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
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

  Future<void> fetchOrders() async {
    final url = "https://animex-95911-default-rtdb.firebaseio.com/orders.json";
    final response = await http.get(url);
    List<OrderItems> loadedOrder = [];
    final extractedOrder = json.decode(response.body) as Map<String, dynamic>;
    extractedOrder.forEach((orderId, orderData) {
      loadedOrder.add(OrderItems(
        id: orderId,
        products: (orderData["products"] as List<dynamic>)
            .map((e) => CartItem(
                  id: e["id"],
                  title: e["title"],
                  price: e["price"],
                  quantity: e["quantity"],
                ))
            .toList(),
        amount: orderData["amount"],
        dateTime: DateTime.parse(
          orderData["dateTime"],
        ),
      ));
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(
    List<CartItem> cartProducts,
    double total,
  ) async {
    try {
      final url =
          "https://animex-95911-default-rtdb.firebaseio.com/orders.json";
      final timeStamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "price": cp.price,
                    "quantity": cp.quantity,
                    "title": cp.title,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItems(
          id: json.decode(response.body)["name"],
          products: cartProducts,
          amount: total,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpsException("Cannot order right now!");
    }
  }
}
