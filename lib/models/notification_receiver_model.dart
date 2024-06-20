import 'package:flutter_teamonapp/models/user_model.dart';

class NotificationReceiver {
  int id;
  int notificationId;
  int userId;
  String status;
  UserModel user;

  NotificationReceiver({
    required this.status,
    required this.id,
    required this.notificationId,
    required this.userId,
    required this.user,
  });

  factory NotificationReceiver.fromJson(Map<String, dynamic> json) =>
      NotificationReceiver(
        status: json["status"],
        id: json["id"],
        notificationId: json["notificationId"],
        userId: json["userId"],
        user: UserModel.fromJson(json["User"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "notificationId": notificationId,
        "userId": userId,
        "User": user.toJson(),
      };
}
