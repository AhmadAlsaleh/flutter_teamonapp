class NotificationReceiver {
  int id;
  int notificationId;
  int userId;
  String status;

  NotificationReceiver({
    required this.status,
    required this.id,
    required this.notificationId,
    required this.userId,
  });

  factory NotificationReceiver.fromJson(Map<String, dynamic> json) =>
      NotificationReceiver(
        status: json["status"],
        id: json["id"],
        notificationId: json["notificationId"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "notificationId": notificationId,
        "userId": userId,
      };
}
