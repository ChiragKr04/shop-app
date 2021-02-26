import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Products with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  bool isFavorite;
  final String imageUrl;
  Products({
    @required this.id,
    @required this.title,
    @required this.desc,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void isFavoriteToggle() async {
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://animex-95911-default-rtdb.firebaseio.com/products/$id.json";
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            "isFavorite": isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpsException("Cannot add to favourite");
    }
  }
}
