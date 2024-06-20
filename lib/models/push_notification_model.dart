class PushNotificationModel {
  final String title;
  final String body;
  final int senderId;
  final List<int> userIds;

  PushNotificationModel({
    required this.title,
    required this.body,
    required this.senderId,
    required this.userIds,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "senderId": senderId,
        "userIds": List<dynamic>.from(userIds.map((x) => x)),
      };
}
