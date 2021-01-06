import 'package:flutter/material.dart';
import '../widgets/AppDrawer.dart';
import 'package:provider/provider.dart';
import '../objects/Product.dart';
import '../products.dart';
import 'editproduct.dart';
import '../authentication.dart';

class ManageProduts extends StatelessWidget {
  static const String route = 'ManageProduts';

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<Products>(context);
    var pp = Provider.of<Auth>(context, listen: false);

    // p.chargelist(b: true);
    List<Product> products =
        p.products.where((element) => element.owner == pp.UserId).toList();

    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, EditScreen.route, arguments: {
              'userid': pp.UserId,
              'scaffold': 'Add Product',
              'title': '',
              'price': '',
              'description': '',
              'imageurl': '',
              'id': ''
            }),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, i) => ProductTile(
          width: width,
          i: i,
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final int i;
  final double width;
  ProductTile({this.i, this.width});
  @override
  Widget build(BuildContext context) {
    var p = Provider.of<Products>(context);
    var pp = Provider.of<Auth>(context, listen: false);
    List<Product> products =
        p.products.where((element) => element.owner == pp.UserId).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: width * 0.02),
          child: ListTile(
            trailing: Container(
              width: width * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(
                        context, EditScreen.route,
                        arguments: {
                          'owner': products[i].owner,
                          'scaffold': 'Edit Product',
                          'title': products[i].title,
                          'price': products[i].price,
                          'description': products[i].description,
                          'imageurl': products[i].imageUrl,
                          'id': products[i].id
                        }),
                    icon: Icon(
                      Icons.create,
                      color: Colors.purple,
                      size: width * 0.07,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      p.delete(i);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: width * 0.07,
                    ),
                  )
                ],
              ),
            ),
            title: Text(products[i].title),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(products[i].imageUrl),
              radius: width * 0.06,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
