import 'dart:convert';

class SubscriptionResponse {
  final bool success;
  final String message;
  final List<Subscription> data;
  final Pagination pagination;

  SubscriptionResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      success: json['success'],
      message: json['message'],
      data: List<Subscription>.from(json['data'].map((x) => Subscription.fromJson(x))),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Subscription {
  final int id;
  final Package package;
  final int amountPaid;
  final int originalPrice;
  final int discountPercentage;
  final int savingsAmount;
  final String startDate;
  final String endDate;
  final String status;
  final int remainingDays;
  final bool isActive;
  final String paymentMethod;
  final String createdAt;

  Subscription({
    required this.id,
    required this.package,
    required this.amountPaid,
    required this.originalPrice,
    required this.discountPercentage,
    required this.savingsAmount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.remainingDays,
    required this.isActive,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      package: Package.fromJson(json['package']),
      amountPaid: json['amount_paid'],
      originalPrice: json['original_price'],
      discountPercentage: json['discount_percentage'],
      savingsAmount: json['savings_amount'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      remainingDays: json['remaining_days'],
      isActive: json['is_active'],
      paymentMethod: json['payment_method'],
      createdAt: json['created_at'],
    );
  }
}

class Package {
  final int id;
  final String name;
  final List<Feature> features;
  final List<Feature> activeFeatures;
  final List<Feature> inactiveFeatures;
  final int activeFeaturesCount;
  final int inactiveFeaturesCount;

  Package({
    required this.id,
    required this.name,
    required this.features,
    required this.activeFeatures,
    required this.inactiveFeatures,
    required this.activeFeaturesCount,
    required this.inactiveFeaturesCount,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      features: List<Feature>.from(json['features'].map((x) => Feature.fromJson(x))),
      activeFeatures: List<Feature>.from(json['active_features'].map((x) => Feature.fromJson(x))),
      inactiveFeatures: List<Feature>.from(json['inactive_features'].map((x) => Feature.fromJson(x))),
      activeFeaturesCount: json['active_features_count'],
      inactiveFeaturesCount: json['inactive_features_count'],
    );
  }
}

class Feature {
  final String name;
  final String active;

  Feature({
    required this.name,
    required this.active,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      name: json['name'],
      active: json['active'],
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}