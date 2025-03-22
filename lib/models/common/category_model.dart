List<Category> categoryListFromJson(List jsonList) => List<Category>.from(jsonList.map((x) => Category.fromJson(x)));

class Category {
  int id;
  String title;
  String image;
  int? categoryId;

  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Category>? subCategories;

  Category({
    required this.id,
    required this.title,
    required this.image,
    this.categoryId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.subCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        status: json["status"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        subCategories: json["sub_categories"] == null ? null : List<Category>.from(json["sub_categories"].map((x) => Category.fromJson(x))),
      );
}
