import 'dart:convert';

import 'package:ajeer/models/auth/customer/user_model.dart';
import 'package:ajeer/models/common/category_model.dart';
import 'package:ajeer/models/customer/provider/slider_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';

CustomerHome customerHomeFromJson(String str) => CustomerHome.fromJson(json.decode(str));

class CustomerHome {
  Customer user;
  List<SliderModel> sliders;
  List<Category> categories;
  List<ServiceProvider> topSelling;
  List<ServiceProvider> randomServiceProviders;

  CustomerHome({
    required this.user,
    required this.sliders,
    required this.categories,
    required this.topSelling,
    required this.randomServiceProviders,
  });

  factory CustomerHome.fromJson(Map<String, dynamic> json) => CustomerHome(
        user: Customer.fromJson(json["user"]),
        sliders: List<SliderModel>.from(json["sliders"].map((x) => SliderModel.fromJson(x))),
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        topSelling: List<ServiceProvider>.from(json["top_selling"].map((x) => ServiceProvider.fromJson(x))),
        randomServiceProviders: List<ServiceProvider>.from(json["random"].map((x) => ServiceProvider.fromJson(x))),
      );
}
