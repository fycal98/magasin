import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Orders.dart';
import '../objects/Order.dart';

class OrderItem extends StatelessWidget {
  final int i;
  OrderItem({this.i});
  @override
  Widget build(BuildContext context) {
    return Consumer<Orders>(
      builder: (context, value, child) => Card(
        child: ExpansionTile(
          title: Text('\$${value.orders[i].total}'),
          subtitle: Text(
            value.orders[i].date.toString(),
            style: TextStyle(color: Colors.grey),
          ),
          children: value.orders[i].orderlist
              .map((e) => OrderTile(
                    price: e.price,
                    title: e.title,
                    count: e.count,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final int count;
  final String title;
  final double price;
  const OrderTile({this.price, this.title, this.count});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        '$count x \$$price',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
