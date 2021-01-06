import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../objects/Product.dart';
import '../products.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  static const String route = 'EditScreen';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool isloading = false;
  var title = FocusNode();

  var Price = FocusNode();

  var Description = FocusNode();

  var imageurl = FocusNode();

  var form = GlobalKey<FormState>();
  Future<void> click(BuildContext context) async {
    final p = Provider.of<Products>(context, listen: false);
    final List<Product> products = p.products;
    setState(() {
      isloading = true;
    });
    if (save()) {
      if (p.products
          .where((element) => element.id == product.id)
          .toList()
          .isEmpty) {
        p.add(product).then((_) {
          setState(() {
            isloading = false;
            Navigator.pop(context);
          });
        }).catchError((_) {
          setState(() {
            isloading = false;
          });

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text('error'),
                    actions: [
                      FlatButton(
                        child: Text('ok'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ));
        });
      } else {
        setState(() {
          isloading = true;
        });
        p.edit(product).then((value) {
          setState(() {
            Navigator.pop(context);
            isloading = false;
          });
        });
      }
    }
  }

  bool save() {
    if (form.currentState.validate()) {
      form.currentState.save();

      return true;
    }
    return false;
  }

  @override
  void initState() {
    imageurl.addListener(() {
      if (!imageurl.hasFocus) {
        setState(() {});
      }
    });

    super.initState();
  }

  Product product = Product(
      title: '',
      price: 0,
      id: '',
      description: '',
      imageUrl: '',
      isFavorite: false);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final p = Provider.of<Products>(context);
    final List<Product> products = p.products;
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;
    var urlcontroller = TextEditingController(text: map['imageurl']);
    product = Product(
        owner: map['owner'],
        title: product.title,
        isFavorite: product.isFavorite,
        imageUrl: product.imageUrl,
        description: product.description,
        id: map['id'],
        price: product.price);
    return Scaffold(
      appBar: AppBar(
        title: Text(map['scaffold']),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              click(context);
            },
          )
        ],
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
              key: form,
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: map['title'],
                      onSaved: (value) {
                        product = Product(
                            owner: product.owner,
                            title: value,
                            isFavorite: product.isFavorite,
                            imageUrl: product.imageUrl,
                            description: product.description,
                            id: product.id,
                            price: product.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please entre a value';
                        }
                        return null;
                      },
                      // focusNode: title,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    TextFormField(
                      initialValue: map['price'].toString(),
                      onSaved: (value) {
                        product = Product(
                            owner: product.owner,
                            title: product.title,
                            isFavorite: product.isFavorite,
                            imageUrl: product.imageUrl,
                            description: product.description,
                            id: product.id,
                            price: double.parse(value));
                      },
                      validator: (value) {
                        if (double.tryParse(value) == null) {
                          return 'please enter a number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter a correct number';
                        }
                        return null;
                      },
                      //focusNode: Price,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {},
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                    TextFormField(
                      initialValue: map['description'],
                      onSaved: (value) {
                        product = Product(
                            owner: product.owner,
                            title: product.title,
                            isFavorite: product.isFavorite,
                            imageUrl: product.imageUrl,
                            description: value,
                            id: product.id,
                            price: product.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a value';
                        }
                        return null;
                      },
                      // focusNode: Description,
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: width * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            width: width * 0.3,
                            height: width * 0.3,
                            child: urlcontroller.value.text.isEmpty
                                ? Text('Enter a URL')
                                : Image.network('${urlcontroller.value.text}'),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: width * 0.02),
                              child: TextFormField(
                                onSaved: (value) {
                                  product = Product(
                                      owner: product.owner,
                                      title: product.title,
                                      isFavorite: product.isFavorite,
                                      imageUrl: value,
                                      description: product.description,
                                      id: product.id,
                                      price: product.price);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'please provide a value';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                onFieldSubmitted: (_) {
                                  if (save()) {
                                    if (p.products
                                        .where((element) =>
                                            element.id == product.id)
                                        .toList()
                                        .isEmpty) {
                                      p.add(product);
                                    } else
                                      p.edit(product);

                                    Navigator.pop(context);
                                  }
                                },
                                controller: urlcontroller,
                                focusNode: imageurl,
                                decoration: InputDecoration(
                                  labelText: 'Image URL',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
    );
  }
}
