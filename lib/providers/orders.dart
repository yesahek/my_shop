import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://flutter-update-66270-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((OId, OData) {
      loadedOrders.add(
        OrderItem(
          id: OId,
          amount: OData['amount'],
          dataTime: DateTime.parse(OData['dateTime']),
          producst: (OData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducs, double total) async {
    const url =
        'https://flutter-update-66270-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducs
            .map((ci) => {
                  'id': ci.id,
                  'title': ci.title,
                  'quantity': ci.quantity,
                  'price': ci.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        producst: cartProducs,
        dataTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
