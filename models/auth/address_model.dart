List<Address> addressFromJson(List jsonList) => List<Address>.from(jsonList.map((x) => Address.fromJson(x)));

class Address {
  int? id;
  int? customerId;
  int? cityId;
  int? regionId;
  String? title;
  String? address;
  String? lat;
  String? lng;
  String? type;
  dynamic notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  Address({
    this.id,
    this.customerId,
    this.cityId,
    this.regionId,
    this.title,
    this.address,
    this.lat,
    this.lng,
    this.type,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        customerId: json["customer_id"],
        cityId: json["city_id"],
        regionId: json["region_id"],
        title: json["title"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        type: json["type"],
        notes: json["notes"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}
