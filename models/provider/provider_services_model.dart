import 'dart:convert';

import 'package:ajeer/models/customer/service_model.dart';

ProviderServices providerServicesFromJson(String str) => ProviderServices.fromJson(json.decode(str));

class ProviderServices {
  List<Service>? workingOn;
  List<Service>? done;

  ProviderServices({
    this.workingOn,
    this.done,
  });

  factory ProviderServices.fromJson(Map<String, dynamic> json) => ProviderServices(
        workingOn: json["working_on"] == null ? [] : List<Service>.from(json["working_on"]!.map((x) => Service.fromJson(x))),
        done: json["done"] == null ? [] : List<Service>.from(json["done"]!.map((x) => Service.fromJson(x))),
      );
}
