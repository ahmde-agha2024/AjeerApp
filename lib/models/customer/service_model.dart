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

  Service({
    this.id,
    this.customer,
    this.provider,
    this.categoryId,
    this.subcategoryId,
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
    this.private,
    this.lat,
    this.lng,
    this.gallery,
    this.tags,
    this.createdAt,
    this.isRated,
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
        service_status: json["service_status"],
        featured: json["featured"],
        private: json["private"],
        lat: json["lat"],
        lng: json["lng"],
        gallery: json["gallery"],
        tags: json["tags"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isRated: json["israte"],
      );
}
