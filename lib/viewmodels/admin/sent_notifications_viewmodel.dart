import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:flutter_teamonapp/models/push_notification_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

final sentNotificationsViewModelProvider = StateNotifierProvider<
    SentNotificationNotifier, AsyncValue<List<NotificationModel>>>(
  (ref) => SentNotificationNotifier(
    ref.read(apiServiceProvider),
    ref.watch(authViewModelProvider),
  ),
);

class SentNotificationNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final ApiService _apiService;
  final AsyncValue<AuthModel?> authModelAsync;

  SentNotificationNotifier(this._apiService, this.authModelAsync)
      : super(const AsyncData([])) {
    fetchData();
  }

  void fetchData() async {
    try {
      var authModel = authModelAsync.valueOrNull;
      if (authModel == null) return;
      state = const AsyncValue.loading();
      var notifications = await _apiService.getSentNotifications(
        token: authModel.token,
        userId: authModel.userId,
      );

      notifications.sort((a, b) => b.id.compareTo(a.id));
      state = AsyncValue.data(notifications);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<bool> pushNotification(
      PushNotificationModel pushNotificationModel) async {
    var authModel = authModelAsync.valueOrNull;
    if (authModel == null) return false;

    state = const AsyncValue.loading();
    var isPushed = await _apiService.pushNotifications(pushNotificationModel,
        token: authModel.token);
    if (isPushed) fetchData();
    return isPushed;
  }
}
