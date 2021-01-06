class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String owner;
  bool isFavorite;
  Product(
      {this.id,
      this.title,
      this.imageUrl,
      this.description,
      this.isFavorite = false,
      this.price,
      this.owner});
}
