class SliderModel {
  int id;
  String title;
  String content;
  String image;
  int status;
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
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    image: json["image"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

}