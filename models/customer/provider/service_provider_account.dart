import 'dart:convert';

import 'package:ajeer/models/common/category_model.dart';

ServiceProviderAccount serviceProviderAccountFromJson(
    Map<String, dynamic> jsonMap) => ServiceProviderAccount.fromJson(jsonMap);

String serviceProviderAccountToJson(ServiceProviderAccount data) =>
    json.encode(data.toJson());

List<City> citiesFromJson(List jsonList) =>
    List<City>.from(jsonList.map((x) => City.fromJson(x)));

class ServiceProviderAccount {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? address;
  String? lat;
  String? lng;
  String? nationalId;
  String? commercialRegister;
  String? taxCard;
  String? wallet;
  String? points;
  int? status;
  String? deviceToken;
  String? otp;
  int? verified;
  int? categoryId;
  int? cityId;
  int? stars;
  int? experience;
  String? about;
  int? offerCount;
  DateTime? createdAt;
  int? id_verifed;
  City? city;
  List<Card>? cards;
  DateTime? updatedAt;
  List<Category>? subCategories;

  ServiceProviderAccount({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.address,
    this.lat,
    this.lng,
    this.nationalId,
    this.commercialRegister,
    this.taxCard,
    this.wallet,
    this.points,
    this.status,
    this.deviceToken,
    this.otp,
    this.verified,
    this.categoryId,
    this.cityId,
    this.stars,
    this.experience,
    this.about,
    this.offerCount,
    this.createdAt,
    this.updatedAt,
    this.subCategories,
    this.city,
    this.cards,
    this.id_verifed
  });

  factory ServiceProviderAccount.fromJson(Map<String, dynamic> json) =>
      ServiceProviderAccount(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        nationalId: json["national_id"],
        commercialRegister: json["commercial_register"],
        taxCard: json["tax_card"],
        wallet: json["wallet"],
        points: json["points"],
        status: json["status"],
        id_verifed: json["id_verified"],
        deviceToken: json["device_token"],
        otp: json["otp"],
        verified: json["verified"],
        categoryId: json["category_id"],
        cityId: json["city_id"],
        stars: json["stars"],
        experience: json["experience"],
        about: json["about"],
        offerCount: json["offer_count"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(
            json["updated_at"]),
        subCategories: json["sub_categories"] == null ? [] : List<
            Category>.from(
            json["sub_categories"]!.map((x) => Category.fromJson(x))),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        cards: json["cards"] == null ? [] : List<Card>.from(
            json["cards"]!.map((x) => Card.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "address": address,
        "lat": lat,
        "lng": lng,
        "national_id": nationalId,
        "commercial_register": commercialRegister,
        "tax_card": taxCard,
        "wallet": wallet,
        "points": points,
        "status": status,
        "device_token": deviceToken,
        "otp": otp,
        "verified": verified,
        "category_id": categoryId,
        "stars": stars,
        "experience": experience,
        "about": about,
        "created_at": createdAt?.toIso8601String(),
        "city": city?.toJson(),
        "cards": cards == null ? [] : List<dynamic>.from(
            cards!.map((x) => x.toJson())),
      };
}

class Card {
  int? id;
  String? title;
  String? image;
  int? providerId;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Card({
    this.id,
    this.title,
    this.image,
    this.providerId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Card.fromJson(Map<String, dynamic> json) =>
      Card(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        providerId: json["provider_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(
            json["updated_at"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "title": title,
        "image": image,
        "provider_id": providerId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class City {
  int? id;
  String? title;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  City({
    this.id,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) =>
      City(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(
            json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(
            json["updated_at"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "title": title,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
