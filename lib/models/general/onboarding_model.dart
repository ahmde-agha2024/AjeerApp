import 'dart:convert';

List<OnBoardingModel> onBoardingModelFromJson(String str) => List<OnBoardingModel>.from(json.decode(str).map((x) => OnBoardingModel.fromJson(x)));

class OnBoardingModel {
  int id;
  String title;
  String content;
  String image;

  OnBoardingModel({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
  });

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) => OnBoardingModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
      );
}
