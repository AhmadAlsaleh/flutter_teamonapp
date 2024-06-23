import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/push_notification_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/admin/sent_notifications_viewmodel.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

final pushNotificationsProvider =
    StateNotifierProvider<PushNotificationNotifier, AsyncValue<bool>>(
  (ref) => PushNotificationNotifier(
    ref.read(apiServiceProvider),
    ref.read(sentNotificationsViewModelProvider.notifier),
    ref.watch(authViewModelProvider),
  ),
);

class PushNotificationNotifier extends StateNotifier<AsyncValue<bool>> {
  final ApiService _apiService;
  final AsyncValue<AuthModel?> authModelAsync;
  final SentNotificationNotifier sentNotificationsNotifier;

  PushNotificationNotifier(
      this._apiService, this.sentNotificationsNotifier, this.authModelAsync)
      : super(const AsyncData(false));

  Future<bool> pushNotification(
      PushNotificationModel pushNotificationModel) async {
    var authModel = authModelAsync.valueOrNull;

    state = const AsyncValue.loading();
    var isPushed = await _apiService.pushNotifications(pushNotificationModel,
        token: authModel?.token);
    state = AsyncValue.data(isPushed);

    if (isPushed) sentNotificationsNotifier.fetchData();
    return isPushed;
  }
}
