import 'dart:convert';

Customer customerFromJson(Map<String, dynamic> jsonMap) => Customer.fromJson(jsonMap);

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  int id;
  String name;
  dynamic email;
  String phone;
  String image;
  int status;
  int verified;
  dynamic lat;
  dynamic lng;
  dynamic address;
  int wallet;
  int points;
  DateTime createdAt;
  DateTime updatedAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.status,
    required this.verified,
    required this.lat,
    required this.lng,
    required this.address,
    required this.wallet,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        status: json["status"],
        verified: json["verified"],
        lat: json["lat"],
        lng: json["lng"],
        address: json["address"],
        wallet: json["wallet"],
        points: json["points"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "status": status,
        "verified": verified,
        "lat": lat,
        "lng": lng,
        "address": address,
        "wallet": wallet,
        "points": points,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
