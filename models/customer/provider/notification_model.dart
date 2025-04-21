import 'dart:convert';

List<UserNotification> notificationListFromJson(String str) => List<UserNotification>.from(json.decode(str).map((x) => UserNotification.fromJson(x)));

class UserNotification {
  String? id;
  int? notifiableId;
  NotificationData? data;
  dynamic readAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserNotification({
    this.id,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) => UserNotification(
        id: json["id"],
        notifiableId: json["notifiable_id"],
        data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
        readAt: json["read_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class NotificationData {
  String? title;
  String? body;
  String? type;
  int? id;

  NotificationData({
    this.title,
    this.body,
    this.type,
    this.id,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        title: json["title"],
        body: json["body"],
        type: json["type"],
        id: json["id"],
      );
}
