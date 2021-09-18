import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final num price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  bool isCart = false;

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, num price, String imageUrl) {
    if (_items.containsKey(productId)) {
      // change qty...
      _items.update(
        productId,
        (oldCart) => CartItem(
          id: oldCart.id,
          title: oldCart.title,
          price: oldCart.price,
          quantity: oldCart.quantity + 1,
          imageUrl: imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  addOrRemoveQuantity(String keyId, bool operators, String imageUrl) {
    if (_items.containsKey(keyId)) {
      _items.update(
        keyId,
        (oldCartItem) => CartItem(
            id: oldCartItem.id,
            title: oldCartItem.title,
            price: oldCartItem.price,
            quantity:
                operators ? oldCartItem.quantity + 1 : oldCartItem.quantity - 1,
            imageUrl: imageUrl),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (!_items.containsKey(prodId)) {
      return;
    }
    if (_items[prodId]!.quantity > 1) {
      _items.update(
          prodId,
          (oldCartItem) => CartItem(
              id: oldCartItem.id,
              title: oldCartItem.title,
              quantity: oldCartItem.quantity - 1,
              price: oldCartItem.price,
              imageUrl: oldCartItem.imageUrl));
    } else {
      _items.remove(prodId);
    }
    notifyListeners();
  }
}
