import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
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

  Future<void> fetchData() async {
    try {
      var authModel = authModelAsync.valueOrNull;

      state = const AsyncValue.loading();
      var notifications = await _apiService.getSentNotifications(
        token: authModel?.token,
        userId: authModel?.userId,
      );

      notifications.sort((a, b) => b.id.compareTo(a.id));
      state = AsyncValue.data(notifications);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
