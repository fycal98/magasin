import 'objects/Product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  String Token;
  String userid;
  Products(this.Token, this.userid);
  List<Product> products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  void delete(int value) {
    String id = products[value].id;
    products.removeAt(value);
    notifyListeners();
    http.delete(
        'https://magasin-e7145.firebaseio.com/products/${id}.json?auth=$Token');
  }

  Future<void> chargelist({bool b = false}) async {
    products = [];
    var reponce;
    var favorites = await http.get(
      'https://magasin-e7145.firebaseio.com/favorites/$userid.json?auth=$Token',
    );

    try {
      if (b == true) {
        reponce = await http.get(
          'https://magasin-e7145.firebaseio.com/products.json?auth=$Token&orderBy="owner"&equalTo="$userid"',
        );
      } else
        reponce = await http.get(
          'https://magasin-e7145.firebaseio.com/products.json?auth=$Token',
        );
      if (reponce.statusCode >= 400) {
        throw reponce.statusCode;
      }

      Map<String, dynamic> map = jsonDecode(reponce.body);
      Map<String, dynamic> fav = jsonDecode(favorites.body) ?? {'': ''};

      map.forEach((key, value) {
        Product prod = Product(
            owner: value['owner'],
            isFavorite: fav.containsKey(key) ? fav[key]['isfavorite'] : false,
            description: value['description'],
            id: key,
            imageUrl: value['imageurl'],
            price: double.parse(value['price']),
            title: value['title']);
        products.add(prod);
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> edit(Product p) async {
    var reponce = await http.patch(
        'https://magasin-e7145.firebaseio.com/products/${p.id}.json?auth=$Token',
        body: jsonEncode({
          'owner': userid,
          'title': p.title,
          'price': p.price.toString(),
          'description': p.description,
          'imageurl': p.imageUrl
        }));

    products[products.indexWhere((element) => element.id == p.id)] = p;
    notifyListeners();
  }

  Future<void> add(Product p) async {
    final String url =
        'https://magasin-e7145.firebaseio.com/products.json?auth=$Token';
    try {
      var reponce = await http.post(url,
          body: jsonEncode({
            'owner': userid,
            'title': p.title,
            'price': p.price.toString(),
            'description': p.description,
            'imageurl': p.imageUrl,
            'isfavorite': false
          }));
      print('not found0');
      if (reponce.body == 'not found') {
        throw 'not found';
      }

      products.add(p);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> favorite(Product p) async {
    int i = products.indexOf(p);
    products[i].isFavorite = !products[i].isFavorite;
    notifyListeners();
    var reponce = await http.put(
        'https://magasin-e7145.firebaseio.com/favorites/$userid/${products[i].id}.json?auth=$Token',
        body: jsonEncode({'isfavorite': products[i].isFavorite}));
  }
// var _showFavoritesOnly = false;

}
