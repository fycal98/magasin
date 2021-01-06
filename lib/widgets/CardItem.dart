import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Cards.dart';

class CardItem extends StatelessWidget {
  double height;
  int i;
  CardItem({this.height, this.i});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.005, horizontal: height * 0.02),
      child: Consumer<Cards>(
        builder: (context, value, child) => Dismissible(
          confirmDismiss: (_) {
            Future<bool> val = showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Are you sure'),
                  content: Text('do you want to remove this product from card'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('No')),
                    FlatButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Yes')),
                  ],
                );
              },
            );
            return val;
          },
          direction: DismissDirection.endToStart,
          onDismissed: (_) => value.removecard(i),
          background: Container(
            padding: EdgeInsets.only(right: height * 0.01),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: height * 0.06,
            ),
            constraints: BoxConstraints.expand(),
            color: Colors.red,
          ),
          key: Key(value.cards[i].id),
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.01),
              child: ListTile(
                leading: CircleAvatar(
                  radius: height * 0.03,
                  child: Padding(
                    padding: EdgeInsets.all(height * 0.002),
                    child: FittedBox(
                      child: Text(
                        '\$${value.cards[i].price}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.purple,
                ),
                title: Text(value.cards[i].title),
                subtitle: Text(
                    'Total: \$${value.cards[i].price * value.cards[i].count}'),
                trailing: Text('${value.cards[i].count} x'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
