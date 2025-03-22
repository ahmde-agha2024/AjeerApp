List<ProviderSubscriptionPackage> providerSubscriptionPackagesFromJson(List jsonList) => List<ProviderSubscriptionPackage>.from(jsonList.map((x) => ProviderSubscriptionPackage.fromJson(x)));

class ProviderSubscriptionPackage {
  int? id;
  String? title;
  String? image;
  int? offers;
  int? price;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProviderSubscriptionPackage({
    this.id,
    this.title,
    this.image,
    this.offers,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProviderSubscriptionPackage.fromJson(Map<String, dynamic> json) => ProviderSubscriptionPackage(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        offers: json["offers"],
        price: json["price"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}
