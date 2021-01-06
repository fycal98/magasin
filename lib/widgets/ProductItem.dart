import 'package:flutter/material.dart';
import '../screens/ProductScreen.dart';
import 'package:provider/provider.dart';
import '../products.dart';
import '../Cards.dart';

class ProductItem extends StatelessWidget {
  final String url;
  final String title;
  final double price;
  final int i;
  bool favorite;
  final String des;
  ProductItem(
      {this.title, this.url, this.i, this.des, this.price, this.favorite});

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<Products>(context, listen: false);
    var m = Provider.of<Cards>(context, listen: false);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ProductScreen.route,
          arguments: {'url': url, 'title': title, 'des': des, 'price': price}),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          child: Hero(
            tag: title,
            child: Image.network(
              url,
              fit: BoxFit.fill,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.9),
            title: Text(title),
            leading: Consumer<Products>(
              builder: (context, value, child) {
                return !favorite
                    ? IconButton(
                        key: key,
                        icon: Icon(
                          value.products[i].isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {
                          value.favorite(value.products[i]);
                        })
                    : IconButton(
                        key: key,
                        icon: Icon(
                          value.products
                                  .where(
                                      (element) => element.isFavorite == true)
                                  .toList()[i]
                                  .isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {
                          value.favorite(value.products
                              .where((element) => element.isFavorite == true)
                              .toList()[i]);
                        });
              },
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.deepOrange),
                onPressed: () {
                  m.addtocard(p.products[i].id, p.products[i].price,
                      p.products[i].title);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Product added to card'),
                    action: SnackBarAction(label: 'Ok', onPressed: () {}),
                  ));
                }),
          ),
        ),
      ),
    );
  }
}
