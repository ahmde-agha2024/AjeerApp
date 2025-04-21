AboutAppModel aboutAppFromJson(Map<String, dynamic> jsonMap) => AboutAppModel.fromJson(jsonMap);

class AboutAppModel {
  int? id;
  String? title;
  String? logo;
  String? favicon;
  String? phone;
  String? email;
  String? facebook;
  String? twitter;
  String? instagram;
  String? linkedin;
  int? trail;
  int? allow;
  DateTime? createdAt;
  DateTime? updatedAt;

  AboutAppModel({
    this.id,
    this.title,
    this.logo,
    this.favicon,
    this.phone,
    this.email,
    this.facebook,
    this.twitter,
    this.instagram,
    this.linkedin,
    this.trail,
    this.allow,
    this.createdAt,
    this.updatedAt,
  });

  factory AboutAppModel.fromJson(Map<String, dynamic> json) => AboutAppModel(
        id: json["id"],
        title: json["title"],
        logo: json["logo"],
        favicon: json["favicon"],
        phone: json["phone"],
        email: json["email"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
        trail: json["trail"],
        allow: json["allow"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

List<Faq> faqFromJson(List jsonList) => List<Faq>.from(jsonList.map((x) => Faq.fromJson(x)));

class Faq {
  int? id;
  String? title;
  String? content;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Faq({
    this.id,
    this.title,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}
