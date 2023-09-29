import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String? authToken;
  final String? userId;
  List<OrderItem> _orders = [];
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https('flutter-update-69ace-default-rtdb.firebaseio.com',
        'orders/$userId.json', params);
    final response = await http.get(url);

    final List<OrderItem> loadedItems = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedItems.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((result) => CartItem(
                  id: result['id'],
                  price: result['price'],
                  quantity: result['quantity'],
                  title: result['title'],
                  imageurl: result['imageurl']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedItems.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https('flutter-update-69ace-default-rtdb.firebaseio.com',
        'orders/$userId.json', params);
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'imageurl': cp.imageurl,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'].toString(),
            amount: total,
            products: cartProducts,
            dateTime: timeStamp,
          ));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
