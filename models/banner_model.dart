class BannerModel {
  final String id;
  final String title;
  final String img;
  final int order;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.title,
    required this.img,
    required this.order,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'],
      title: json['title'],
      img: json['img'],
      order: json['order'],
      isActive: json['isActive'],
    );
  }
}
