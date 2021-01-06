import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  static const String route = 'ProductScreen';

  @override
  Widget build(BuildContext context) {
    Map m = ModalRoute.of(context).settings.arguments;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(m['title']),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: height * 0.3,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                child: Text(m['title']),
                //color: Colors.black.withOpacity(0.4),
              ),
              background: Hero(
                tag: m['title'],
                child: Image.network(
                  m['url'],
                  height: height * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(height * 0.01),
                child: Center(
                    child: Text(
                  '\$${m['price']}',
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                )),
              ),
              Padding(
                padding: EdgeInsets.all(height * 0.01),
                child: Center(child: Text(m['des'])),
              ),
              SizedBox(
                height: 1000,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
