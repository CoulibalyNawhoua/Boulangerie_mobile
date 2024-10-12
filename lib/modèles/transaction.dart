class Transaction {
  int totalAmount;
  int typePayment;
  DateTime createdAt;
  String name;

  Transaction({
    required this.totalAmount,
    required this.typePayment,
    required this.createdAt,
    required this.name,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      totalAmount: json['total_amount'] ?? 0,
      typePayment: json["type_payment"] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_amount': totalAmount,
      "type_payment": typePayment,
      'created_at': createdAt.toIso8601String(),
      "name": name,
    };
  }
}
