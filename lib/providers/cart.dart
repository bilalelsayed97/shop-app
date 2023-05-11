import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageurl;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.imageurl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem>? _items = {};

  Map<String, CartItem> get items {
    return {..._items!};
  }

  int get itmeCount {
    return (_items!.length);
  }

  double? get totalAmount {
    var total = 0.0;
    items.forEach((key, value) {
      total += value.quantity * value.price.toInt();
    });
    return total != null ? total : 0;
  }

  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
  }

  void undoItem(String productId) {
    if (!_items!.containsKey(productId)) {
      return;
    }
    if (_items![productId]!.quantity > 1) {
      _items!.update(
          productId,
          (value) => CartItem(
              id: value.id,
              price: value.price,
              quantity: value.quantity - 1,
              title: value.title,
              imageurl: value.imageurl));
    } else {
      _items!.remove(productId);
    }
    notifyListeners();
  }

  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items!.containsKey(productId)) {
      _items!.update(
        productId,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            quantity: value.quantity + 1,
            title: value.title,
            imageurl: value.imageurl),
      );
    } else {
      //add new item
      _items!.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
          imageurl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }
}
