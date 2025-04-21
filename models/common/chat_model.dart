import 'package:ajeer/models/customer/service_model.dart';
import 'package:ajeer/models/customer/service_provider_model.dart';
import 'package:ajeer/models/provider/home/provider_home_model.dart';

List<ChatHead> chatHeadsFromJson(List jsonList) => List<ChatHead>.from(jsonList.map((x) => ChatHead.fromJson(x)));

class ChatHead {
  int? id;
  ServiceProvider? provider;
  Customer? customer;
  ChatMessage? lastMessage;
  Service? service;
  int? unreadCount;
  DateTime? createdAt;

  ChatHead({
    this.id,
    this.provider,
    this.customer,
    this.lastMessage,
    this.service,
    this.unreadCount,
    this.createdAt,
  });

  factory ChatHead.fromJson(Map<String, dynamic> json) => ChatHead(
        id: json["id"],
        provider: json["provider"] == null ? null : ServiceProvider.fromJson(json["provider"]),
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        lastMessage: json["last_message"] == null ? null : ChatMessage.fromJson(json["last_message"]),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        unreadCount: json["unread_count"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );
}

class ChatMessage {
  int? id;
  int? chatId;
  int? customerId;
  int? providerId;
  String? message;
  String? sender;
  String? type;
  int? seen;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatMessage({
    this.id,
    this.chatId,
    this.customerId,
    this.providerId,
    this.message,
    this.sender,
    this.type,
    this.seen,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        chatId: json["chat_id"],
        customerId: json["customer_id"],
        providerId: json["provider_id"],
        message: json["message"],
        sender: json["sender"],
        type: json["type"],
        seen: json["seen"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

SingleChat singleChatFromJson(Map<String, dynamic> jsonMap) => SingleChat.fromJson(jsonMap);

class SingleChat {
  int? id;
  ServiceProvider? provider;
  Customer? customer;
  Service? service;
  List<ChatMessage>? messages;
  DateTime? createdAt;

  SingleChat({
    this.id,
    this.provider,
    this.customer,
    this.service,
    this.messages,
    this.createdAt,
  });

  factory SingleChat.fromJson(Map<String, dynamic> json) => SingleChat(
        id: json["id"],
        provider: json["provider"] == null ? null : ServiceProvider.fromJson(json["provider"]),
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        messages: json["messages"] == null ? [] : List<ChatMessage>.from(json["messages"]!.map((x) => ChatMessage.fromJson(x))),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );
}
