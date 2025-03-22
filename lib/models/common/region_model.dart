List<Region> regionsFromJson(List jsonList) => List<Region>.from(jsonList.map((x) => Region.fromJson(x)));

class Region {
  int? id;
  String? title;
  int? cityId;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Region({
    this.id,
    this.title,
    this.cityId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        title: json["title"],
        cityId: json["city_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}
