import 'dart:convert';

import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';

import '../provider/home/provider_home_model.dart';

ServiceResponse serviceResponseFromJson(String str) =>
    ServiceResponse.fromJson(json.decode(str));

List<Service> servicesListFromJson(List jsonList) =>
    List<Service>.from(jsonList.map((x) => Service.fromJson(x)));

class ServiceResponse {
  List<Service> currentServices;
  List<Service> doneServices;

  ServiceResponse({
    required this.currentServices,
    required this.doneServices,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      ServiceResponse(
        currentServices:
            List<Service>.from(json["current"].map((x) => Service.fromJson(x))),
        doneServices:
            List<Service>.from(json["done"].map((x) => Service.fromJson(x))),
      );
}

class Service {
  int? id;
  Customer? customer;
  ServiceProvider? provider;
  Category? categoryId;
  Category? subcategoryId;
  Category? category;
  Category? subcategory;
  String? address;
  String? title;
  String? date;
  String? time;
  String? content;
  String? image;
  double? price;
  int? stars;
  int? views;
  String? status;
  String? service_status;
  bool? isRated;
  int? featured;
  int? private;
  String? lat;
  String? lng;
  dynamic gallery;
  dynamic tags;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdAtHuman;
  UserAddress? userAddress;
  List<OfferUser>? offers;

  Service({
    this.id,
    this.customer,
    this.provider,
    this.categoryId,
    this.subcategoryId,
    this.category,
    this.subcategory,
    this.address,
    this.title,
    this.date,
    this.time,
    this.content,
    this.image,
    this.price,
    this.stars,
    this.views,
    this.status,
    this.service_status,
    this.featured,
    this.userAddress,
    this.private,
    this.lat,
    this.lng,
    this.gallery,
    this.tags,
    this.createdAt,
    this.isRated,
    this.updatedAt,
    this.createdAtHuman,
    this.offers,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        provider: json["provider"] == null
            ? null
            : ServiceProvider.fromJson(json["provider"]),
        categoryId: json["category_id"] == null ||
                json["category_id"].runtimeType == int
            ? null
            : Category.fromJson(json["category_id"]),
        subcategoryId: json["subcategory_id"] == null ||
                json["category_id"].runtimeType == int
            ? null
            : Category.fromJson(json["subcategory_id"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        subcategory: json["subcategory"] == null ? null : Category.fromJson(json["subcategory"]),
        address: json["address"],
        title: json["title"],
        date: json["date"],
        time: json["time"],
        content: json["content"],
        image: json["image"],
        price: double.parse(json["price"].toString()),
        stars: json["stars"],
        views: json["views"],
        status: json["status"],
        service_status: json["service_status"]??"NEW",
        featured: json["featured"],
        private: json["private"],
        lat: json["lat"],
        lng: json["lng"],
        gallery: json["gallery"],
        userAddress: json["useraddress"] == null
            ? null
            : UserAddress.fromJson(json["useraddress"]),
        tags: json["tags"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAtHuman: json["created_at_human"],
        offers: json["offers"] == null ? null : List<OfferUser>.from(json["offers"].map((x) => OfferUser.fromJson(x))),
        isRated: json["israte"],
      );
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

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Region {
  int? id;
  String? title;
  int? cityId;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Region({
    this.id,
    this.title,
    this.cityId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        title: json["title"],
        cityId: json["city_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "city_id": cityId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class UserAddress {
  int? id;
  int? customerId;
  int? cityId;
  int? regionId;
  String? title;
  String? address;
  String? lat;
  String? lng;
  String? type;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;
  City? city;
  Region? region;
  List<dynamic>? offers;

  UserAddress({
    this.id,
    this.customerId,
    this.cityId,
    this.regionId,
    this.title,
    this.address,
    this.lat,
    this.lng,
    this.type,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.region,
    this.offers,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json["id"],
        customerId: json["customer_id"],
        cityId: json["city_id"],
        regionId: json["region_id"],
        title: json["title"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        type: json["type"],
        notes: json["notes"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        region: json["region"] == null ? null : Region.fromJson(json["region"]),
        offers: json["offers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "city_id": cityId,
        "region_id": regionId,
        "title": title,
        "address": address,
        "lat": lat,
        "lng": lng,
        "type": type,
        "notes": notes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "city": city?.toJson(),
        "region": region?.toJson(),
        "offers": offers,
      };

  String get fullAddress {
    final parts = [
      address,
      region?.title,
      city?.title,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }

  bool get isValid => lat != null && lng != null && address != null && address!.isNotEmpty;
}

// Helper function to parse a list of addresses
List<UserAddress> userAddressesFromJson(List<dynamic> json) =>
    List<UserAddress>.from(json.map((x) => UserAddress.fromJson(x)));

// Helper function to convert a list of addresses to JSON
List<Map<String, dynamic>> userAddressesToJson(List<UserAddress> addresses) =>
    List<Map<String, dynamic>>.from(addresses.map((x) => x.toJson()));

class OfferUser {
  int? id;
  int? serviceId;
  int? providerId;
  int? customerId;
  double? price;
  String? date;
  String? time;
  String? content;
  String? status;
  double? ajeerProfit;
  double? providerProfit;
  String? paymentMethod;
  String? paymentStatus;
  dynamic paymentId;
  dynamic paymentData;
  dynamic notes;
  dynamic gallery;
  dynamic reason;
  DateTime? createdAt;
  DateTime? updatedAt;
  ServiceProvider? provider;

  OfferUser({
    this.id,
    this.serviceId,
    this.providerId,
    this.customerId,
    this.price,
    this.date,
    this.time,
    this.content,
    this.status,
    this.ajeerProfit,
    this.providerProfit,
    this.paymentMethod,
    this.paymentStatus,
    this.paymentId,
    this.paymentData,
    this.notes,
    this.gallery,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.provider,
  });

  factory OfferUser.fromJson(Map<String, dynamic> json) => OfferUser(
        id: json["id"],
        serviceId: json["service_id"],
        providerId: json["provider_id"],
        customerId: json["customer_id"],
        price: json["price"] != null ? double.tryParse(json["price"].toString()) : null,
        date: json["date"],
        time: json["time"],
        content: json["content"],
        status: json["status"],
        ajeerProfit: json["ajeer_profit"] != null ? double.tryParse(json["ajeer_profit"].toString()) : null,
        providerProfit: json["provider_profit"] != null ? double.tryParse(json["provider_profit"].toString()) : null,
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        paymentId: json["payment_id"],
        paymentData: json["payment_data"],
        notes: json["notes"],
        gallery: json["gallery"],
        reason: json["reason"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        provider: json["provider"] == null ? null : ServiceProvider.fromJson(json["provider"]),
      );
}
