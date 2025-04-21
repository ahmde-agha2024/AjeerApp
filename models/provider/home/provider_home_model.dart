// To parse this JSON data, do
//
//     final providerHomePage = providerHomePageFromJson(jsonString);

import 'dart:convert';

import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/provider/service_provider_account.dart';
import 'package:ajeer/models/customer/service_model.dart';

ProviderHomePage providerHomePageFromJson(String str) => ProviderHomePage.fromJson(json.decode(str));

class ProviderHomePage {
  ServiceProviderAccount? providerAccount;
  List<Category>? sliders;
  List<Category>? categories;
  List<Service>? latestServices;
  List<dynamic>? workingOn;
  List<dynamic>? pendingOffers;
  Stats? stats;
  ProviderHomeChart? chart;

  ProviderHomePage({
    this.providerAccount,
    this.sliders,
    this.categories,
    this.latestServices,
    this.workingOn,
    this.pendingOffers,
    this.stats,
    this.chart,
  });

  factory ProviderHomePage.fromJson(Map<String, dynamic> json) => ProviderHomePage(
        providerAccount: json["user"] == null ? null : ServiceProviderAccount.fromJson(json["user"]),
        sliders: json["sliders"] == null ? [] : List<Category>.from(json["sliders"]!.map((x) => Category.fromJson(x))),
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        latestServices: json["latest_services"] == null ? [] : List<Service>.from(json["latest_services"]!.map((x) => Service.fromJson(x))),
        workingOn: json["working_on"] == null ? [] : List<dynamic>.from(json["working_on"]!.map((x) => x)),
        pendingOffers: json["pending_offers"] == null ? [] : List<dynamic>.from(json["pending_offers"]!.map((x) => x)),
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        chart: json["chart"] == null ? null : ProviderHomeChart.fromJson(json["chart"]),
      );
}

class Pivot {
  int? providerId;
  int? subcategoryId;

  Pivot({
    this.providerId,
    this.subcategoryId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        providerId: json["provider_id"],
        subcategoryId: json["subcategory_id"],
      );
}

class ProviderHomeChart {
  List<String>? months;
  List<int>? offers;
  List<int>? services;

  ProviderHomeChart({
    this.months,
    this.offers,
    this.services,
  });

  factory ProviderHomeChart.fromJson(Map<String, dynamic> json) => ProviderHomeChart(
        months: json["months"] == null ? [] : List<String>.from(json["months"]!.map((x) => x)),
        offers: json["offers"] == null ? [] : List<int>.from(json["offers"]!.map((x) => x)),
        services: json["services"] == null ? [] : List<int>.from(json["services"]!.map((x) => x)),
      );
}

class Customer {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? status;
  int? verified;
  dynamic lat;
  dynamic lng;
  dynamic address;
  int? wallet;
  int? points;
  DateTime? createdAt;
  DateTime? updatedAt;

  Customer({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.status,
    this.verified,
    this.lat,
    this.lng,
    this.address,
    this.wallet,
    this.points,
    this.createdAt,
    this.updatedAt,
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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class Stats {
  int? offerCount;
  int? offersCount;
  int? acceptedOffers;
  int? doneServices;
  int? workingServices;

  Stats({
    this.offerCount,
    this.offersCount,
    this.acceptedOffers,
    this.doneServices,
    this.workingServices,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        offerCount: json["offer_count"],
        offersCount: json["offers_count"],
        acceptedOffers: json["accepted_offers"],
        doneServices: json["done_services"],
        workingServices: json["working_services"],
      );
}
