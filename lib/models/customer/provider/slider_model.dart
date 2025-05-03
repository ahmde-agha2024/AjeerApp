class SliderModel {
  int id;
  String title;
  String content;
  String image;
  int status;
  int categoryId;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  SliderModel({
    required this.id,
    required this.title,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.categoryId,
    required this.type
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    image: json["image"],
    status: json["status"],
    categoryId: json["category_id"],
    type: json["type"]??"provider",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

}