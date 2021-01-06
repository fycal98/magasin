import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magasin/authentication.dart';
import '../screens/loginscreen.dart';
import '../screens/MainScreen.dart';

class HomeScreen extends StatelessWidget {
  static const String route = 'HomeScreen';
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => FutureBuilder<bool>(
        future: Provider.of<Auth>(context, listen: false).autologin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading');
            return LoginScreen();
          }
          return Consumer<Auth>(
            builder: (context, data, child) =>
                data.isauth ? MainScreen() : LoginScreen(),
          );
        },
      ),
    );
  }
}
