import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return _token != null;
  }

  String get getToken {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return "Token Not Found";
  }

  Future<void> authenticateUser(
      String email, String password, String urlAuth) async {
    try {
      final String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlAuth?key=AIzaSyAbEuHoN904Gp4npfAKvTISmutNSUgcfaA";
      final response = await http.post(
        url,
        // headers: {
        //   "content_type": "application/json",
        // },
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpsException(responseData["error"]["message"].toString());
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(
          responseData["expiresIn"],
        ),
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> singUp(String email, String password) async {
    return authenticateUser(email, password, "signUp");
  }

  Future<void> logIn(String email, String password) async {
    return authenticateUser(email, password, "signInWithPassword");
  }
}
