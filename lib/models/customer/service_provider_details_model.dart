import 'package:ajeer/models/common/category_model.dart';

ServiceProviderDetails serviceProviderDetailsFromJson(Map<String, dynamic> jsonMap) => ServiceProviderDetails.fromJson(jsonMap);

class ServiceProviderDetails {
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
  int? verified;
  Category? category;
  List<Category>? subcategories;
  int? stars;
  List<dynamic>? rate;
  int? experience;
  int? customers;
  List<Work>? work;
  String? about;
  String? createdAt;

  ServiceProviderDetails({
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
    this.verified,
    this.category,
    this.subcategories,
    this.stars,
    this.rate,
    this.experience,
    this.customers,
    this.work,
    this.about,
    this.createdAt,
  });

  factory ServiceProviderDetails.fromJson(Map<String, dynamic> json) => ServiceProviderDetails(
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
        verified: json["verified"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        subcategories: json["subcategories"] == null ? [] : List<Category>.from(json["subcategories"]!.map((x) => Category.fromJson(x))),
        stars: json["stars"],
        rate: json["rate"] == null ? [] : List<dynamic>.from(json["rate"]!.map((x) => x)),
        experience: json["experience"],
        customers: json["customers"],
        work: json["work"] == null ? [] : List<Work>.from(json["work"]!.map((x) => Work.fromJson(x))),
        about: json["about"],
        createdAt: json["created_at"],
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

class Work {
  int id;
  int providerId;
  String title;
  String content;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  Work({
    required this.id,
    required this.providerId,
    required this.title,
    required this.content,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Work.fromJson(Map<String, dynamic> json) => Work(
        id: json["id"],
        providerId: json["provider_id"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
