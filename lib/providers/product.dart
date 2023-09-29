import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  late final String id;
  late final String title;
  late final String description;
  late final double price;
  late final String imageUrl;
  bool isFavourite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourieStatus(var authToken, userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    var params = {
      'auth': authToken,
    };
    final url = Uri.https(
      'flutter-update-69ace-default-rtdb.firebaseio.com',
      'userFavourites/$userId/$id.json',
      params,
    );
    final response = await http.put(
      url,
      body: json.encode(
        isFavourite,
      ),
    );
    if (response.statusCode >= 400) {
      isFavourite = oldStatus;
    }
  }
}
