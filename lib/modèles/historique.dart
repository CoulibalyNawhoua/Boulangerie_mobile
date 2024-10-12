class HistorieProduct {
  int quantity;
  String name;
  String image;
  DateTime createdAt;

  HistorieProduct({
    required this.quantity,
    required this.name,
    required this.image,
    required this.createdAt,
  });

  factory HistorieProduct.fromJson(Map<String, dynamic> json) {
    return HistorieProduct(
      quantity: json['quantity'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
      'image': image,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

