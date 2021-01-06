import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magasin/objects/cardobject.dart';
import '../products.dart';
import '../widgets/ProductItem.dart';
import '../widgets/AppDrawer.dart';
import '../widgets/Badge.dart';
import 'CardScreen.dart';
import 'package:provider/provider.dart';
import '../objects/Product.dart';
import 'package:magasin/Cards.dart';

class MainScreen extends StatefulWidget {
  static const String route = 'MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool favorite = false;
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState

    bool chargelist = false;
    setState(() {
      isloading = true;
    });
    if (!chargelist) {
      var p = Provider.of<Products>(context, listen: false);
      p.chargelist().then((value) {
        if (this.mounted) {
          setState(() {
            isloading = false;
          });
        }
      });
      chargelist = true;
      return;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    List<Product> products = Provider.of<Products>(context).products;
    List<CardObject> cards = Provider.of<Cards>(context).cards;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(onSelected: (b) {
            setState(() {
              favorite = b;
            });
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: true,
                child: Text('Only Favorites'),
              ),
              PopupMenuItem(
                value: false,
                child: Text('Show All'),
              )
            ];
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: GestureDetector(
              child: Badge(
                i: cards.length,
              ),
              onTap: () => Navigator.pushNamed(context, CardScreen.route),
            )),
          )
        ],
        title: Text('My Shop'),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                itemCount: favorite
                    ? products
                        .where((element) => element.isFavorite == true)
                        .toList()
                        .length
                    : products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: width * 0.02,
                    mainAxisSpacing: width * 0.02,
                    childAspectRatio: 3 / 2),
                itemBuilder: (context, i) {
                  return !favorite
                      ? ProductItem(
                          favorite: favorite,
                          price: products[i].price,
                          des: products[i].description,
                          title: products[i].title,
                          url: products[i].imageUrl,
                          i: i,
                        )
                      : ProductItem(
                          favorite: favorite,
                          price: products
                              .where((element) => element.isFavorite == true)
                              .toList()[i]
                              .price,
                          des: products
                              .where((element) => element.isFavorite == true)
                              .toList()[i]
                              .description,
                          title: products
                              .where((element) => element.isFavorite == true)
                              .toList()[i]
                              .title,
                          url: products
                              .where((element) => element.isFavorite == true)
                              .toList()[i]
                              .imageUrl,
                          i: i,
                        );
                },
              ),
      ),
    );
  }
}
