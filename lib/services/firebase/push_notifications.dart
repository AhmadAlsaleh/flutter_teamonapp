import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }
}

final fcmProvider = Provider((ref) => PushNotificationService());
