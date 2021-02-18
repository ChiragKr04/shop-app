import 'package:flutter/foundation.dart';

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

  void isFavoriteToggle() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
