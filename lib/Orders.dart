import 'dart:convert';

import 'objects/Order.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<Order> orders = [
    // Order(
    //     date: DateTime.now(),
    //     total: 259.94,
    //     orderlist: [OrderObject(count: 4, title: 'Trouserrs', price: 100.0)])
  ];
  Future<void> initialise(String token, String userid) async {
    final String url =
        'https://magasin-e7145.firebaseio.com/orders/$userid.json?auth=$token';
    orders = [];
    var reponce = await http.get(url);

    Map<String, dynamic> map = jsonDecode(reponce.body);

    try {
      map.forEach((key, value) {
        List<dynamic> orderse = value['orderlist'];
        Order order = Order(
            date: value['date'],
            total: value['total'],
            orderlist: orderse
                .map((e) => OrderObject(
                    title: e['title'], price: e['price'], count: e['count']))
                .toList());
        orders.add(order);
      });
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> addorder(String token, String userid, double total,
      DateTime date, List<OrderObject> orderlist) async {
    final String url =
        'https://magasin-e7145.firebaseio.com/orders/$userid.json?auth=$token';
    orders.add(Order(
        orderlist: orderlist, total: total, date: date.toIso8601String()));
    notifyListeners();
    var reponce = await http.post(url,
        body: jsonEncode({
          'total': total,
          'date': date.toIso8601String(),
          'orderlist': orderlist
              .map(
                  (e) => {'title': e.title, 'price': e.price, 'count': e.count})
              .toList()
        }));
  }
}
