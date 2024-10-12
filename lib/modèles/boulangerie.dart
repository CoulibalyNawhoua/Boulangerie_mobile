class Boulangerie {
  int id;
  String name;
  String phone;
  String address;
  int dette;

  Boulangerie({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.dette,
  });

  factory Boulangerie.fromJson(Map<String, dynamic> json) => Boulangerie(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    address: json["address"],
    dette: json["dette"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "address": address,
    "dette": dette,
  };
}
