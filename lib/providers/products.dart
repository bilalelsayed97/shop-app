import 'dart:convert';
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/http_exceotion.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Gaming Chair',
    //   description:
    //       'AutoFull Gaming Chair Ergonomic Gamer Chair with 3D Bionic Lumbar Support Racing Style PU Leather Computer Gaming Chair for Adults with Footrest,Brown',
    //   price: 249.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/61a6CxNXFFL._AC_SL1476_.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Video Card',
    //   description:
    //       'GIGABYTE GeForce RTX 3070 Ti Gaming OC 8G Graphics Card, WINDFORCE 3X Cooling System, 8GB 256-bit GDDR6X, GV-N307TGAMING OC-8GD Video Card',
    //   price: 799.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/81ZWSNdXNSS._AC_SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: ' Military Smart Watch',
    //   description:
    //       'ZUKYFIT Military Smart Watch,60+ Days Battery Life(Call Receive/Dial),50M Waterproof Rugged Smart Watch with 70 Sports Modes,1.85" Smartwatch with 24H Smart Sleep Tracking Heart Rate Blood Pressure',
    //   price: 99.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/71QDD+F2RFL._AC_SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'iPhone 13 Pro Max',
    //   description:
    //       'iPhone 13 Pro Max, 128GB, Sierra Blue - Unlocked (Renewed Premium), A like-new experience. Backed by a one-year satisfaction guarantee.',
    //   price: 1029.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/61i8Vjb17SL._AC_SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Red Shirt',
    //   description:
    //       'Essentials Men\'s Slim-Fit Short-Sleeve Crewneck T-Shirt, Pack of 2',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.shopify.com/s/files/1/0102/4593/1044/products/Tatami_Apex_DryFit_Tshirt_red-131_1000x1000.jpg?v=1620904984',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Men Trousers',
    //   description:
    //       'Dockers Men\'s Straight Fit Signature Lux Cotton Stretch Khaki Pant-Creased.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/514DFChKAbL._AC_SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Yellow Scarf',
    //   description:
    //       'woogwin Women\'s Cotton Scarves Lady Light Soft Fashion Solid Scarf Wrap Shawl',
    //   price: 19.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/71RvPAn2QdL._AC_UL1000_.jpg',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'A Pan',
    //   description:
    //       'Ninja C63000 Foodi NeverStick Stainless 8-Inch, 10.25-Inch, & 12-Inch Fry Pan Set, Polished Stainless-Steel Exterior, Nonstick, Durable & Oven Safe to 500°F, Silver',
    //   price: 49.99,
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/81DpUZyLv0L._AC_SL1500_.jpg',
    // ),
  ];
  final String? authToken;
  final String? userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere(
      (prod) => prod.id == id,
    );
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts([var filterByUser = false]) async {
    var params = filterByUser
        ? {
            'auth': authToken,
            'orderBy': json.encode("creatorId"),
            'equalTo': json.encode(userId),
          }
        : {
            'auth': authToken,
          };
    var url = Uri.https('flutter-update-69ace-default-rtdb.firebaseio.com',
        'products.json', params);
    // final url = Uri.https(
    // '<firebase_path>.app', '/products.json', {'auth': '$authToken'});

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.https('flutter-update-69ace-default-rtdb.firebaseio.com',
          'userFavourites/$userId.json', {
        'auth': authToken,
      });
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];

      extractedData.forEach(
        (productId, productData) {
          loadedProducts.add(
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              isFavourite: favouriteData == null
                  ? false
                  : favouriteData[productId] ?? false,
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
      print(json.decode(response.body));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https('flutter-update-69ace-default-rtdb.firebaseio.com',
        'products.json', params);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'date': DateFormat('HH:MM dd MM yyyy').format(DateTime.now()),
            'creatorId': userId,
          },
        ),
      );
      print(json.decode(response.body)['name']);
      final addedProduct = Product(
        id: json.decode(response.body)['name'].toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(addedProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> delProduct(String id) async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https('flutter-update-69ace-default-rtdb.firebaseio.com',
        'products/$id.json', params);

    final exitingProductIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic exitingProduct = _items[exitingProductIndex];
    _items.removeAt(exitingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(exitingProductIndex, exitingProduct);
      notifyListeners();
      throw HttpException('Couldn\'t delete product.');
    }
    exitingProduct = null;
  }

  void undoAddProduct() {
    _items.removeAt(0);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var params = {
      'auth': authToken,
    };
    final index = _items.indexWhere((prod) => prod.id == id);
    final url = Uri.https('flutter-update-69ace-default-rtdb.firebaseio.com',
        'products/$id.json', params);
    if (index >= 0) {
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
      } catch (error) {
        print(error);
      }
      _items[index] = newProduct;
    } else {
      print('wrong update id');
    }

    notifyListeners();
  }
}
