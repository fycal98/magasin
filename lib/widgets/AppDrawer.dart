import 'package:flutter/material.dart';
import '../screens/MainScreen.dart';
import '../screens/OrderScreen.dart';
import '../screens/ManageProducts.dart';
import 'package:provider/provider.dart';
import '../authentication.dart';
import '../screens/loginscreen.dart';
import '../screens/HomeScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool islanscap =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double width = !islanscap
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    double height = !islanscap
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
    double txt = MediaQuery.of(context).textScaleFactor;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            color: Colors.purple,
            height: height * 0.13,
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Text(
                'Hello Friend!',
                style: TextStyle(fontSize: 25 * txt, color: Colors.white),
              ),
            ),
          ),
          Item(
            onclick: () =>
                Navigator.pushReplacementNamed(context, MainScreen.route),
            title: 'Shop',
            width: width,
            icon: Icon(Icons.shop_rounded),
          ),
          Item(
            onclick: () =>
                Navigator.pushReplacementNamed(context, OrderScreen.route),
            title: 'Orders',
            width: width,
            icon: Icon(Icons.credit_card),
          ),
          Item(
            onclick: () =>
                Navigator.pushReplacementNamed(context, ManageProduts.route),
            title: 'Manage Products',
            width: width,
            icon: Icon(Icons.create),
          ),
          Item(
            onclick: () async {
              Navigator.pop(context);
              await Provider.of<Auth>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, HomeScreen.route);
              // Navigator.popUntil(
              //     context, ModalRoute.withName(Navigator.));

              // Navigator.pushReplacementNamed(context, );
            },
            title: 'LOG OUT',
            width: width,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function onclick;
  final double width;
  const Item({this.title, this.icon, this.width, this.onclick});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: width * 0.04, left: width * 0.02),
      child: ListTile(
        onTap: onclick,
        leading: icon,
        title: Text(title),
      ),
    );
  }
}
