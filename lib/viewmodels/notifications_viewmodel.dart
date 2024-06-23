import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/models/auth_model.dart';
import 'package:flutter_teamonapp/models/notification_model.dart';
import 'package:flutter_teamonapp/services/api_service.dart';
import 'package:flutter_teamonapp/viewmodels/auth_viewmodel.dart';

final notificationsViewModelProvider = StateNotifierProvider<
    NotificationNotifier, AsyncValue<List<NotificationModel>>>(
  (ref) => NotificationNotifier(
    ref.read(apiServiceProvider),
    ref.watch(authViewModelProvider),
  ),
);

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final ApiService _apiService;
  final AsyncValue<AuthModel?> authModelAsync;

  NotificationNotifier(this._apiService, this.authModelAsync)
      : super(const AsyncData([])) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var authModel = authModelAsync.valueOrNull;
      if (authModel == null) return;
      state = const AsyncValue.loading();
      var notifications = await _apiService.getNotifications(
        token: authModel.token,
        userId: authModel.userId,
      );

      notifications.sort((a, b) => b.id.compareTo(a.id));
      state = AsyncValue.data(notifications);

      final i = (notifications)
          .where((n) => n.receiver?.status == NotificationModel.UNREAD)
          .toList();
      _updateBadge(i.length);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void read(NotificationModel model) async {
    try {
      var token = authModelAsync.value?.token;
      await _apiService.readNotification(
          token, model.receiver?.userId, model.receiver?.id);

      var newState = state.value ?? [];
      for (var element in newState) {
        if (element.id == model.id) {
          element.receiver?.status = NotificationModel.READ;
        }
      }

      state = AsyncValue.data(newState);

      final i = (state.value ?? [])
          .where((n) => n.receiver?.status == NotificationModel.UNREAD)
          .toList();
      _updateBadge(i.length);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> _updateBadge(int count) async {
    bool res = await FlutterAppBadger.isAppBadgeSupported();
    if (res) FlutterAppBadger.updateBadgeCount(count);
  }
}
