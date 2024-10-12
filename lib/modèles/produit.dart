class Product {
  final int totalQuantity;
  final String name;
  final String image;
  

  Product({
    required this.totalQuantity,
    required this.name,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      totalQuantity: json['total_quantity'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_quantity': totalQuantity,
      'name': name,
      'image': image,
    };
  }
}