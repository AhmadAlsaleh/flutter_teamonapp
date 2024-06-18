import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

final notificationsViewModelProvider = StateNotifierProvider<
    NotificationNotifier, AsyncValue<List<NotificationModel>>>(
  (ref) => NotificationNotifier(
      ref.read(apiServiceProvider), ref.watch(authViewModelProvider)),
);

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final ApiService _apiService;
  final AsyncValue<AuthModel?> authModelAsync;

  NotificationNotifier(this._apiService, this.authModelAsync)
      : super(const AsyncData([])) {
    fetchData();
  }

  void fetchData() async {
    var authModel = authModelAsync.value;

    state = const AsyncValue.loading();
    try {
      var notifications = await _apiService.getNotifications(
        token: authModel?.token,
        userId: authModel?.userId,
      );
      state = AsyncValue.data(notifications);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void read(NotificationModel notification) async {
    try {
      state = const AsyncValue.loading();

      var token = authModelAsync.value?.token;
      await _apiService.readNotification(
          token, notification.userId, notification.id);
      fetchData();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
