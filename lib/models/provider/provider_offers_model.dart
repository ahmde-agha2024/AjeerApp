import 'dart:convert';

import 'package:ajeer/models/common/service_details_model.dart';

ProviderOffers providerOffersFromJson(String str) => ProviderOffers.fromJson(json.decode(str));

class ProviderOffers {
  List<Offer>? pending;
  List<Offer>? accepted;
  List<Offer>? rejected;

  ProviderOffers({
    this.pending,
    this.accepted,
    this.rejected,
  });

  factory ProviderOffers.fromJson(Map<String, dynamic> json) => ProviderOffers(
        pending: json["pending"] == null ? [] : List<Offer>.from(json["pending"]!.map((x) => Offer.fromJson(x))),
        accepted: json["accepted"] == null ? [] : List<Offer>.from(json["accepted"]!.map((x) => Offer.fromJson(x))),
        rejected: json["rejected"] == null ? [] : List<Offer>.from(json["rejected"]!.map((x) => Offer.fromJson(x))),
      );
}
