import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  List<OrderItem> get orders {
    return [..._orders];
  }
  Orders(this.authToken,this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://demoflutter-c92f3-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData== null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders=loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://demoflutter-c92f3-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken");
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProducts.map((cp) {
            return {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price,
            };
          }).toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
