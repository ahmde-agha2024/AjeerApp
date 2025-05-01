import 'package:ajeer/models/common/category_model.dart';

List<ServiceProvider> serviceProviderFromJson(List providersList) =>
    List<ServiceProvider>.from(
        providersList.map((x) => ServiceProvider.fromJson(x)));

List<ServiceProvider> favoriteProvidersFromJson(List providersList) =>
    List<ServiceProvider>.from(
        providersList.map((x) => ServiceProvider.fromJson(x)));

class ServiceProvider {
  int id;
  String name;
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
  double? stars;
  int? status;
  int? verified;
  Category? category;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? offer_count;

  ServiceProvider(
      {required this.id,
      required this.name,
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
      this.stars,
      this.status,
      this.verified,
      this.category,
      this.createdAt,
      this.updatedAt,
      this.offer_count});

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      ServiceProvider(
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
        stars: double.parse(json["stars"].toString()),
        verified: json["verified"],
        offer_count: json["offer_count"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
