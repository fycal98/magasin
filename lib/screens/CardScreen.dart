import 'package:flutter/material.dart';
import 'package:magasin/Orders.dart';
import 'package:magasin/objects/Order.dart';
import 'package:provider/provider.dart';
import '../widgets/CardItem.dart';
import '../objects/cardobject.dart';
import '../Cards.dart';
import '../authentication.dart';

class CardScreen extends StatefulWidget {
  static const String route = 'CardScreen';

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var p = Provider.of<Orders>(context, listen: false);
    var pr = Provider.of<Cards>(context);
    var pp = Provider.of<Auth>(context, listen: false);
    List<CardObject> cards = pr.cards;

    double txt = MediaQuery.of(context).textScaleFactor;
    double height = MediaQuery.of(context).size.height;
    double sum = 0;
    cards.forEach((element) {
      sum = sum + element.price * element.count;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(height * 0.02),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(height * 0.01),
                child: ListTile(
                  title: Text(
                    'Total',
                    style: TextStyle(fontSize: 20 * txt),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text('\$${sum.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.purple,
                      ),
                      TextButton(
                        onPressed: cards.length == 0
                            ? null
                            : () {
                                setState(() {
                                  loading = true;
                                });
                                p
                                    .addorder(
                                        pp.Token,
                                        pp.UserId,
                                        sum,
                                        DateTime.now(),
                                        cards
                                            .map((e) => OrderObject(
                                                price: e.price,
                                                title: e.title,
                                                count: e.count))
                                            .toList())
                                    .then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                                pr.clearcard();
                              },
                        child: loading
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                                'ORDER NOW',
                                style: TextStyle(color: Colors.purple),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, i) => CardItem(
                height: height,
                i: i,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
