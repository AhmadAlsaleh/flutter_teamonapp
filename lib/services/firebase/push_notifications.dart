import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }

  subscribeGenerals() async {
    try {
      String? token = await _fcm.getToken();
      print("token: $token");

      await _fcm.subscribeToTopic("generals");
    } catch (e) {
      print(e);
    }
  }
}

final fcmProvider = Provider((ref) => PushNotificationService());
