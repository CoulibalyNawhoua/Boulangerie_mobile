class User {
  int id;
    String name;
    String email;
    dynamic emailVerifiedAt;
    dynamic apiToken;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic bakehouseId;
    String firstName;
    String lastName;
    int active;
    dynamic username;
    String phone;

  User({
   required this.id,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.apiToken,
        required this.createdAt,
        required this.updatedAt,
        required this.bakehouseId,
        required this.firstName,
        required this.lastName,
        required this.active,
        required this.username,
        required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        apiToken: json["api_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        bakehouseId: json["bakehouse_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        active: json["active"],
        username: json["username"],
        phone: json["phone"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "api_token": apiToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "bakehouse_id": bakehouseId,
        "first_name": firstName,
        "last_name": lastName,
        "active": active,
        "username": username,
        "phone": phone,
    };
  }
}

class Backhouse {
  int id;
  String name;
  String address;
  String phone;

  Backhouse({
      required this.id,
      required this.name,
      required this.address,
      required this.phone,
  });

  factory Backhouse.fromJson(Map<String, dynamic> json) => Backhouse(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "phone": phone,
  };
}


class UserResponse {
  String accessToken;
  String tokenType;
  User user;
  // Backhouse backhouse;


  UserResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    // required this.backhouse,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      user: User.fromJson(json['user']),
      // backhouse: Backhouse.fromJson(json["backhouse"]),
    );
  }
}
