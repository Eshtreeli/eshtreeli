import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  String _someValue = '';
  int _cartValue = 0;
  String get someValue => _someValue;
  int get cartValue => _cartValue;
  void updateSomeValue(n) {
    _someValue = n;
    // print(_someValue);

    notifyListeners();
  }

  void DeleteCart(a) {
    // print(_someValue);
    _cartValue = 0;
    notifyListeners();
  }

  void updateCart() async {
    final response = await http.post(
      Uri.parse('https://e-shtreeli.com/api/get_cart'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': localStorage.getItem('id'),
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['data'].length > 0) {
        var length = jsonDecode(response.body)['data'].length;
        _cartValue = length;
        print(_cartValue);
        // localStorage.setItem('cartvalue', length.toString());
      }
    } else {
      _cartValue = 0;
      throw Exception('فنكشن السلة لا يعمل');
    }
    notifyListeners();
  }
}
