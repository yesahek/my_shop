import 'package:flutter/cupertino.dart';

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

  void addOrder(List<CartItem> cartProducs, double total) {
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
  }
}
