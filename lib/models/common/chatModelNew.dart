import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/models/provider/home/provider_home_model.dart';

class ChatResponse {
  final SingleChatNew data;

  ChatResponse({required this.data});

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        data: SingleChatNew.fromJson(json['data']),
      );
}

SingleChatNew singleChatNewFromJson(Map<String, dynamic> jsonMap) => SingleChatNew.fromJson(jsonMap['data']);

class SingleChatNew {
  int? id;
  ServiceProviderNew? provider;
  CustomerNew? customer;
  Service? service;
  List<ChatMessageNew>? messages;
  DateTime? createdAt;

  SingleChatNew({
    this.id,
    this.provider,
    this.customer,
    this.service,
    this.messages,
    this.createdAt,
  });

  factory SingleChatNew.fromJson(Map<String, dynamic> json) => SingleChatNew(
        id: json["id"],
        provider: json["provider"] == null ? null : ServiceProviderNew.fromJson(json["provider"]),
        customer: json["customer"] == null ? null : CustomerNew.fromJson(json["customer"]),
        messages: json["messages"] == null ? [] : List<ChatMessageNew>.from(json["messages"]!.map((x) => ChatMessageNew.fromJson(x))),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );
}

class ServiceProviderNew {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? passport;
  String? image;
  String? address;
  double? lat;
  double? lng;
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
  String? inviteToken;
  int? hasDiscount;
  int? discountPercent;
  int? idVerified;
  DateTime? createdAt;
  DateTime? updatedAt;

  ServiceProviderNew({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.passport,
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
    this.inviteToken,
    this.hasDiscount,
    this.discountPercent,
    this.idVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceProviderNew.fromJson(Map<String, dynamic> json) => ServiceProviderNew(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        passport: json["passport"],
        image: json["image"],
        address: json["address"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        nationalId: json["national_id"],
        commercialRegister: json["commercial_register"],
        taxCard: json["tax_card"],
        wallet: json["wallet"],
        points: json["points"],
        status: json["status"],
        deviceToken: json["device_token"],
        otp: json["otp"],
        verified: json["verified"],
        categoryId: json["category_id"],
        cityId: json["city_id"],
        stars: json["stars"],
        experience: json["experience"],
        about: json["about"],
        offerCount: json["offer_count"],
        inviteToken: json["invite_token"],
        hasDiscount: json["has_discount"],
        discountPercent: json["discount_percent"],
        idVerified: json["id_verified"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class CustomerNew {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? status;
  int? verified;
  double? lat;
  double? lng;
  String? address;
  int? wallet;
  int? points;
  String? inviteToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  CustomerNew({
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
    this.inviteToken,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerNew.fromJson(Map<String, dynamic> json) => CustomerNew(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        status: json["status"],
        verified: json["verified"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        address: json["address"],
        wallet: json["wallet"],
        points: json["points"],
        inviteToken: json["invite_token"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class ChatMessageNew {
  int? id;
  String? type;
  String? message;
  String? sender;
  ServiceProviderNew? provider;
  CustomerNew? customer;
  DateTime? createdAt;

  ChatMessageNew({
    this.id,
    this.type,
    this.message,
    this.sender,
    this.provider,
    this.customer,
    this.createdAt,
  });

  factory ChatMessageNew.fromJson(Map<String, dynamic> json) => ChatMessageNew(
        id: json["id"],
        type: json["type"],
        message: json["message"],
        sender: json["sender"],
        provider: json["provider"] == null ? null : ServiceProviderNew.fromJson(json["provider"]),
        customer: json["customer"] == null ? null : CustomerNew.fromJson(json["customer"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );
}

