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
  List<ProviderService>? services;
  List<ProviderSubscription>? subscription;

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
    this.services,
    this.subscription,
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
        services: json["services"] == null ? [] : List<ProviderService>.from(json["services"].map((x) => ProviderService.fromJson(x))),
        subscription: json["subscription"] == null ? [] : List<ProviderSubscription>.from(json["subscription"].map((x) => ProviderSubscription.fromJson(x))),
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

class ProviderService {
  int? id;
  int? customerId;
  int? providerId;
  int? categoryId;
  Category? category;
  int? subcategoryId;
  int? addressId;
  String? title;
  String? date;
  String? time;
  String? content;
  String? image;
  int? price;
  int? stars;
  int? views;
  String? status;
  int? featured;
  int? private;
  String? lat;
  String? lng;
  String? address;
  String? gallery;
  String? tags;
  String? createdAt;
  String? updatedAt;
  String? serviceStatus;

  ProviderService({
    this.id,
    this.customerId,
    this.providerId,
    this.categoryId,
    this.subcategoryId,
    this.category,
    this.addressId,
    this.title,
    this.date,
    this.time,
    this.content,
    this.image,
    this.price,
    this.stars,
    this.views,
    this.status,
    this.featured,
    this.private,
    this.lat,
    this.lng,
    this.address,
    this.gallery,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.serviceStatus,
  });

  factory ProviderService.fromJson(Map<String, dynamic> json) => ProviderService(
        id: json["id"],
        customerId: json["customer_id"],
        providerId: json["provider_id"],
        categoryId: json["category_id"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
        subcategoryId: json["subcategory_id"],
        addressId: json["address_id"],
        title: json["title"],
        date: json["date"],
        time: json["time"],
        content: json["content"],
        image: json["image"],
        price: json["price"] is int ? json["price"] : int.tryParse('${json["price"] ?? ''}'),
        stars: json["stars"],
        views: json["views"],
        status: json["status"],
        featured: json["featured"],
        private: json["private"],
        lat: json["lat"],
        lng: json["lng"],
        address: json["address"],
        gallery: json["gallery"],
        tags: json["tags"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        serviceStatus: json["service_status"],
      );
}

class Feature {
  String? name;
  String? active;

  Feature({this.name, this.active});

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        name: json["name"],
        active: json["active"],
      );
}

class NewPackage {
  int? id;
  String? name;
  String? price;
  String? oldPrice;
  int? validityMonths;
  List<Feature>? features;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? color;

  NewPackage({
    this.id,
    this.name,
    this.price,
    this.oldPrice,
    this.validityMonths,
    this.features,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.color,
  });

  factory NewPackage.fromJson(Map<String, dynamic> json) => NewPackage(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        oldPrice: json["old_price"],
        validityMonths: json["validity_months"],
        features: json["features"] == null
            ? []
            : List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
        isActive: json["is_active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        color: json["color"],
      );
}

class ProviderSubscription {
  int? id;
  int? providerId;
  int? newPackageId;
  String? amountPaid;
  String? originalPrice;
  int? discountPercentage;
  String? startDate;
  String? endDate;
  String? status;
  String? paymentMethod;
  String? paymentReference;
  String? createdAt;
  String? updatedAt;
  NewPackage? newPackage;

  ProviderSubscription({
    this.id,
    this.providerId,
    this.newPackageId,
    this.amountPaid,
    this.originalPrice,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.status,
    this.paymentMethod,
    this.paymentReference,
    this.createdAt,
    this.updatedAt,
    this.newPackage,
  });

  factory ProviderSubscription.fromJson(Map<String, dynamic> json) => ProviderSubscription(
        id: json["id"],
        providerId: json["provider_id"],
        newPackageId: json["new_package_id"],
        amountPaid: json["amount_paid"],
        originalPrice: json["original_price"],
        discountPercentage: json["discount_percentage"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        status: json["status"],
        paymentMethod: json["payment_method"],
        paymentReference: json["payment_reference"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        newPackage: json["new_package"] != null ? NewPackage.fromJson(json["new_package"]) : null,
      );
}
