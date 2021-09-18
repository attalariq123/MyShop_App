import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final num price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFovoriteStatus(String? token, String? userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');

    try {
      final res = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (res.statusCode >= 400) {
        print('try error');
        throw HttpException('Could not change favorite status');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      print('catch error');
      throw HttpException('Could not change favorite status');
    }
  }
}
