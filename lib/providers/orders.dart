import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/providers/products.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> producst;
  final DateTime dataTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.producst,
      required this.dataTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducs, double total) async {
    const url =
        'https://flutter-update-66270-default-rtdb.firebaseio.com/orders.json';
    try {
      await http.post(Uri.parse(url),
          body: json.encode({
            'id': DateTime.now().toString(),
            'amount': total,
            'prodacts': cartProducs,
            'dataTime': DateTime.now(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          producst: cartProducs,
          dataTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
