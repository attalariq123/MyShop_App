import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  // to get _items
  List<Product> get items {
    return [..._items];
  }

  // to filter favorite items
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // to find id of each items
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  final String? authToken;
  final String? userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  Future<void> fetchProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString');

    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return null;
      }
      url = Uri.parse(
          'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteRes = await http.get(url);
      final favoriteData = json.decode(favoriteRes.body);
      // print(res.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProduct;
      notifyListeners();
      return Future.delayed(Duration(milliseconds: 700));
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );
      // print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();

      return Future.delayed(Duration(milliseconds: 500));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
      return Future.delayed(Duration(milliseconds: 500));
    } else {
      print('update failed');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    try {
      final res = await http.delete(url);
      if (res.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Deleting Failed!');
      }
      _items.removeAt(existingProductIndex);
      notifyListeners();
      existingProduct = null;

      // return Future.delayed(Duration(milliseconds: 500));
    } catch (error) {
      throw (error);
    }
  }
}
