import 'dart:convert';

List<NotificationModel> notificationFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

class NotificationModel {
  int id;
  int userId;
  DateTime createdAt;
  String status;
  String title;
  String body;

  static const READ = "read";
  static const UNREAD = "unread";

  NotificationModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.status,
    required this.title,
    required this.body,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        status: json["status"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "dateTime": createdAt.toIso8601String(),
        "status": status,
        "title": title,
        "body": body,
      };
}
