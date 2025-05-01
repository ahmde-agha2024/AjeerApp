// To parse this JSON data, do
//
//     final serviceDetails = serviceDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:ajeer/models/auth/customer/user_model.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';

ServiceDetails serviceDetailsFromJson(String str) => ServiceDetails.fromJson(json.decode(str)['data']);

class ServiceDetails {
  int id;
  Customer customer;
  ServiceProvider? provider;
  int category;
  Category subcategory;
  String title;
  String content;
  String? date;
  String image;
  double price;
  int stars;
  int views;
  String status;
  int private;
  dynamic address;
  dynamic gallery;
  dynamic tags;
  int featured;
  DateTime createdAt;
  List<Offer>? offers;
  Offer? acceptedOffer;

  ServiceDetails({
    required this.id,
    required this.customer,
    required this.provider,
    required this.category,
    required this.subcategory,
    required this.title,
    required this.content,
    required this.date,
    required this.image,
    required this.price,
    required this.stars,
    required this.views,
    required this.status,
    required this.private,
    required this.address,
    required this.gallery,
    required this.tags,
    required this.featured,
    required this.createdAt,
    required this.offers,
    required this.acceptedOffer,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) => ServiceDetails(
        id: json["id"],
        customer: Customer.fromJson(json["customer"]),
        provider: json["provider"] == null ? null : ServiceProvider.fromJson(json["provider"]),
        category: json["category"],
        subcategory: Category.fromJson(json["subcategory"]),
        title: json["title"],
        content: json["content"],
        date: json["date"],
        image: json["image"],
        price: double.parse("${json["price"]}"),
        stars: json["stars"],
        views: json["views"],
        status: json["status"],
        private: json["private"],
        address: json["address"],
        gallery: json["gallery"],
        tags: json["tags"],
        featured: json["featured"],
        createdAt: DateTime.parse(json["created_at"]),
        offers: json["offers"] == null ? [] : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
        acceptedOffer: json["accepted_offer"] == null ? null : Offer.fromJson(json["accepted_offer"]),
      );
}

class Offer {
  int? id;
  int? serviceId;
  Service? service;
  ServiceProvider? provider;
  int? customerId;
  double? price;
  String? date;
  String? time;
  String? content;
  String? status;
  int? ajeerProfit;
  int? providerProfit;
  String? paymentMethod;
  String? paymentStatus;
  dynamic paymentId;
  dynamic paymentData;
  dynamic notes;
  dynamic gallery;
  dynamic reason;
  DateTime? createdAt;
  DateTime? updatedAt;


  Offer({
    this.id,
    this.serviceId,
    this.service,
    this.provider,
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

  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        serviceId: json["service_id"],
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        provider: json["provider"] == null ? null : ServiceProvider.fromJson(json["provider"]),
        customerId: json["customer_id"],
        price: double.parse("${json["price"]}"),
        date: json["date"],
        time: json["time"],
        content: json["content"],
        status: json["status"],
        ajeerProfit: json["ajeer_profit"],
        providerProfit: json["provider_profit"],
        paymentMethod: json["payment_method"],
        paymentStatus: json["payment_status"],
        paymentId: json["payment_id"],
        paymentData: json["payment_data"],
        notes: json["notes"],
        gallery: json["gallery"],
        reason: json["reason"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}
