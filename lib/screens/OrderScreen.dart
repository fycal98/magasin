import 'package:flutter/material.dart';
import '../widgets/AppDrawer.dart';
import '../widgets/OrderItem.dart';
import '../objects/Order.dart';
import 'package:provider/provider.dart';
import '../Orders.dart';
import '../authentication.dart';

class OrderScreen extends StatefulWidget {
  static const String route = 'OrderScreen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    var p = Provider.of<Orders>(context, listen: false);
    var pp = Provider.of<Auth>(context, listen: false);
    List<Order> orders = p.orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: p.initialise(pp.Token, pp.UserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<Orders>(
            builder: (context, orders, child) => ListView.builder(
                itemCount: orders.orders.length,
                itemBuilder: (context, i) {
                  return OrderItem(
                    i: i,
                  );
                }),
          );
        },
      ),
    );
  }
}
