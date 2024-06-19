import 'dart:convert';

import 'package:flutter_teamonapp/models/notification_receiver_model.dart';
import 'package:flutter_teamonapp/models/user_model.dart';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  int id;
  String title;
  String body;
  DateTime createdAt;
  List<NotificationReceiver> notificationReceivers;
  UserModel sender;

  static const READ = 'read';
  static const UNREAD = 'unread';

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.notificationReceivers,
    required this.sender,
  });

  NotificationReceiver? get receiver => notificationReceivers.firstOrNull;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        createdAt: DateTime.parse(json["createdAt"]),
        notificationReceivers: List<NotificationReceiver>.from(
            json["NotificationReceivers"]
                .map((x) => NotificationReceiver.fromJson(x))),
        sender: UserModel.fromJson(json["Sender"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "createdAt": createdAt.toIso8601String(),
        "NotificationReceivers":
            List<dynamic>.from(notificationReceivers.map((x) => x.toJson())),
        "Sender": sender.toJson(),
      };
}
