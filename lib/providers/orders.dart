import 'package:flutter/foundation.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final num amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final int itemQty;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.itemQty,
  });
}

class Orders with ChangeNotifier {
  final String? authToken;
  List<OrderItem> _orders = [];
  final String? userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchSetOrders() async {
    final url = Uri.parse(
        'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final res = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(res.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      _orders = [];
      notifyListeners();
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          itemQty: orderData['itemCount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['product'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                    imageUrl: item['image'],
                  ))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
    return Future.delayed(Duration(milliseconds: 500));
  }

  Future<void> addOrder(
      List<CartItem> cartProducts, num amount, int qty) async {
    final url = Uri.parse(
        'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final res = await http.post(
      url,
      body: json.encode({
        'amount': amount,
        'dateTime': timestamp.toIso8601String(),
        'itemCount': qty,
        'product': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                  'image': cp.imageUrl,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(res.body)['name'],
        amount: amount,
        dateTime: DateTime.now(),
        products: cartProducts,
        itemQty: qty,
      ),
    );
    notifyListeners();
  }

  Future<void> deleteOrder(String id) async {
    final url = Uri.parse(
        'https://flutter-course-ccab3-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId/$id.json?auth=$authToken');
    final existingOrderIndex = _orders.indexWhere((order) => order.id == id);
    OrderItem? existingOrder = _orders[existingOrderIndex];
    try {
      final res = await http.delete(url);
      if (res.statusCode >= 400) {
        _orders.insert(existingOrderIndex, existingOrder);
        notifyListeners();
        throw HttpException('Delete order failed!');
      }
      _orders.removeAt(existingOrderIndex);
      notifyListeners();
      existingOrder = null;
    } catch (error) {
      throw error;
    }
  }

}
