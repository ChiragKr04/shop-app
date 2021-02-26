import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import './products.dart';

class ProductsProvider with ChangeNotifier {
  List<Products> _items = [
    // Products(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   desc: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Products(
    //   id: 'p2',
    //   title: 'Trousers',
    //   desc: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Products(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   desc: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Products(
    //   id: 'p4',
    //   title: 'Pan',
    //   desc: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavoriteOnly = false;

  void showFavouriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  List<Products> get favoriteItem {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Products> get items {
    if (_showFavoriteOnly) {
      return _items.where((element) => element.isFavorite).toList();
    }
    return [..._items];
  }

  Products findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  static const url =
      "https://animex-95911-default-rtdb.firebaseio.com/products.json";

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Products> loadedProduct = [];
      extractedData.forEach((key, value) {
        print(value["price"].runtimeType);
        loadedProduct.add(
          Products(
            id: key,
            isFavorite: value["isFavorite"],
            title: value["title"],
            desc: value["desc"],
            imageUrl: value["imageUrl"],
            price: double.parse(value["price"].toString()),
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Products product) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "desc": product.desc,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "isFavorite": product.isFavorite,
          },
        ),
      );
      // print(json.decode(response.body));
      final newProduct = Products(
        id: json.decode(response.body)["name"],
        title: product.title,
        desc: product.desc,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Products newProduct) async {
    final prodIndex = _items.indexWhere((element) => id == element.id);
    if (prodIndex >= 0) {
      final url =
          "https://animex-95911-default-rtdb.firebaseio.com/products/$id.json";
      try {
        await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "desc": newProduct.desc,
              "price": newProduct.price,
              "imageUrl": newProduct.imageUrl,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      print(">>><<<");
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingIndex = _items.indexWhere((element) => id == element.id);
    var existingItem = _items[existingIndex];
    final url =
        "https://animex-95911-default-rtdb.firebaseio.com/products/$id.json";
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingItem);
      notifyListeners();
      throw HttpsException("Cannot delete this product");
    }
    existingItem = null;
  }
}
