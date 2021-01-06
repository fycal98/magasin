import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  int i;
  Badge({this.i});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Icon(
          Icons.shopping_cart,
          color: Colors.white,
          size: 30.0,
        ),
        CircleAvatar(
          radius: 8.0,
          child: FittedBox(child: Text(i.toString())),
          backgroundColor: Colors.red,
        )
      ],
    );
  }
}
