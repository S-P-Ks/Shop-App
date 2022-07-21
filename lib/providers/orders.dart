import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final String amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        "https://shop-app-ac0fd-default-rtdb.firebaseio.com/orders.json";
    try {
      final response = await http.get(Uri.parse(url));

      List<OrderItem> loadedList = [];
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((orderId, orderData) {
        print(orderData["amount"].runtimeType);
        loadedList.add(
          OrderItem(
            id: orderId,
            amount: orderData["amount"] ?? "0.0",
            dateTime: DateTime.parse(
              orderData["datetime"],
            ),
            products: (orderData["products"] as List<dynamic>)
                .map((item) => CartItem(
                      id: item["id"],
                      title: item["title"],
                      quantity: item["quantity"],
                      price: item["[price]"],
                    ))
                .toList(),
          ),
        );
      });
      _orders = loadedList;

      print(_orders);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final uri =
        "https://shop-app-ac0fd-default-rtdb.firebaseio.com/orders.json";

    final res = await http.post(Uri.parse(uri),
        body: json.encode({
          "amount": total.toString(),
          "datetime": DateTime.now().toIso8601String(),
          "products": cartProducts
              .map((e) => {
                    "id": e.id,
                    "title": e.title,
                    "quantity": e.quantity,
                    "price": e.price
                  })
              .toList()
        }));

    _orders.insert(
      0,
      OrderItem(
          id: jsonDecode(res.body)["name"],
          amount: total.toString(),
          dateTime: DateTime.now(),
          products: cartProducts),
    );
    notifyListeners();
  }
}
