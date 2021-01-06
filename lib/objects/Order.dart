class OrderObject {
  final String title;
  final int count;
  final double price;
  OrderObject({this.count, this.title, this.price});
}

class Order {
  final double total;
  final String date;
  List<OrderObject> orderlist;
  Order({this.date, this.orderlist, this.total});
}
