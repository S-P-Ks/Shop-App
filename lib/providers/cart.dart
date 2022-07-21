import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    var t = 0.0;
    _items.forEach((key, value) {
      t += value.price * value.quantity;
    });

    return t;
  }

  void removeItems(String productId) {
    _items.removeWhere((key, value) => value.id == productId);
    notifyListeners();
  }

  void addItem(String productId, String title, int quantity, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: productId,
              title: title,
              quantity: quantity + 1,
              price: price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: productId, title: title, quantity: quantity, price: price));
    }
    notifyListeners();
  }

  void undoAdd(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingValue) => CartItem(
          id: _items[productId]!.id,
          title: _items[productId]!.title,
          quantity: _items[productId]!.quantity,
          price: _items[productId]!.price,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
